#include <err.h>
#include <fcntl.h>
#include <inttypes.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <assert.h>
#include <stdint.h>
#include <sys/stat.h>
#include <ctype.h>
#include <stdbool.h>

#define __USE_GNU
#include <pthread.h>
#include <semaphore.h>
#include "linkedq.h"
#include <sys/epoll.h>
#include <errno.h>
#define MAXEVENTS            128
#define OPTIONS              "t:l:"
#define BUF_SIZE             4096
#define DEFAULT_THREAD_COUNT 4
static FILE *logfile;
#define buf     4096
#define urisize 19
extern int errno;
#define LOG(...) fprintf(logfile, __VA_ARGS__);
volatile sig_atomic_t run = 0;
int threads = 0;

struct t_pool {
    int t_count;
    int isActive;
    struct node *work;
    pthread_t *pool;
    pthread_mutex_t lock;
    pthread_cond_t condition;
    sem_t semaphore;
    //int wait;

} pool;

// Converts a string to an 16 bits unsigned integer.
// Returns 0 if the string is malformed or out of the range.
static size_t strtouint16(char number[]) {
    char *last;
    long num = strtol(number, &last, 10);
    if (num <= 0 || num > UINT16_MAX || *last != '\0') {
        return 0;
    }
    return num;
}
// Creates a socket for listening for connections.
// Closes the program and prints an error message on error.
static int create_listen_socket(uint16_t port);
//make sockets non_blocking using O_NONBLOCK flag
static int non_block_socket(uint16_t port);

struct request { //struct request stores connfd stuffs into its corresponding data sets
    char method[buf]; //for method
    char uri[buf]; //for uri
    char version[buf]; //for version of HTTP/#.#
    int isvalid_method;
    char methodname[8];
    int status_code;
    int hf_content_leng; //if request has content_leng key, store the value here
    int hf_request_id;
    int request_line_leng;
    //holds size of requestline and headerfields and not messagebody
};
//PUT: 1
//APPEND: 2
//GET: 3
static int isValidMethod(struct request *quest) {
    if (strncmp(quest->method, "PUT", strlen(quest->method)) == 0) {
        return 1;
    } else if (strncmp(quest->method, "APPEND", strlen(quest->method)) == 0) {
        return 2;
    } else {
        return 3;
    }
}
static int handle_request_line(struct request *quest) {
    quest->isvalid_method = isValidMethod(quest);
    return quest->isvalid_method;
}
static int handle_header_fields_message_body(struct request *quest, char *buffer) {

    //another if statement to strstr to check if there is a message body
    //printf("buffer: %s\n", buffer);
    char *tok = NULL;
    char *tempmsg = NULL;
    tempmsg = strstr(buffer, "\r\n\r\n"); //pointer to end of the header_field
    if (tempmsg) {
        tok = malloc(
            (tempmsg - buffer) + 1); //malloc header_field space (end of header - buffer) + 1
        if (tok) {
            memcpy(tok, buffer,
                tempmsg
                    - buffer); //copy buffer header_field to tok with space(end of header - buffer)
            tok[tempmsg - buffer] = '\0'; //set NULL terminate at \r\n
            //printf("tok: %s\n", tok);
            char *checkContent_Length_size = NULL;
            checkContent_Length_size = strstr(tok, "Content-Length: "); //check content_length
            //printf("checkContent_length: %s\n",checkContent_Length_size);
            if (checkContent_Length_size != NULL) { //sscanf for key: Content-Length
                sscanf(checkContent_Length_size, "Content-Length: %d", &quest->hf_content_leng);
            }

            char *checkRequest_id_size = NULL;
            checkRequest_id_size = strstr(tok, "Request-Id"); //check request_id
            if (checkRequest_id_size != NULL) {
                sscanf(checkRequest_id_size, "Request-Id: %d", &quest->hf_request_id);
            }
        }
        free(tok);
    }

    return quest->isvalid_method;
}
//handles the checks for request_line, header_fields, message_body
static int handle_protocol(struct request *quest, char *buffer) {
    char *saveptr = NULL;
    char *tok = NULL;
    tok = strtok_r(buffer, "\r\n", &saveptr); //delimit
    if (sscanf(tok, "%s %s %s", quest->method, quest->uri, quest->version) != 3) {
        return -1;
    }
    int check = 0;
    check = handle_request_line(quest);
    check = handle_header_fields_message_body(quest, saveptr);
    return check;
}

static void usage(char *exec) {
    fprintf(stderr, "usage: %s [-t threads] [-l logfile] <port>\n", exec);
}

static void handle_connection(int connfd) {
    //create variables
    char *buffer = calloc(BUF_SIZE + 1, sizeof(char));
    char *tempbuff = calloc(BUF_SIZE + 1, sizeof(char));
    memset(buffer, '\0', BUF_SIZE + 1);
    struct request quest;
    memset(tempbuff, '\0', BUF_SIZE + 1);
    //HTTP Responses
    memset(quest.method, '\0', sizeof(quest.method));
    memset(quest.uri, '\0', sizeof(quest.uri));
    memset(quest.version, '\0', sizeof(quest.version));
    quest.isvalid_method = -1;
    memset(quest.methodname, '\0', sizeof(quest.methodname));
    quest.status_code = 404;
    quest.hf_request_id = 0;
    quest.hf_content_leng = 0;
    quest.request_line_leng = 0;
    char ok[] = "HTTP/1.1 200 OK\r\nContent-Length: 3\r\n\r\nOK\n";
    char cd[] = "HTTP/1.1 201 Created\r\nContent-Length: 8\r\n\r\nCreated\n";
    char nf[] = "HTTP/1.1 404 Not Found\r\nContent-Length: 10\r\n\r\nNot Found\n";
    char se[]
        = "HTTP/1.1 500 Internal Server Error\r\nContent-Length: 22\r\n\r\nInternal Server Error\n";
    int reads = 0;
    if ((reads = recv(connfd, buffer, BUF_SIZE, 0)) > 0) {
        strcpy(tempbuff, buffer); //copy buffer values into tempbuff
        //printf("tempbuff: %s", tempbuff);
        int cases = 0;
        int i = 0;
        for (i = 0; i < reads; i++) {
            if (buffer[i] == '\n' && buffer[i - 2] == '\n') {
                i++;
                quest.request_line_leng = i;
                //printf("i: %d\n", i);
                break;
            }
        }

        cases = handle_protocol(&quest, tempbuff);
        char temp[buf];
        //printf("quest.rqlhf: %d\n", quest.request_line_leng);
        memset(temp, '\0', sizeof(temp));
        strcpy(temp, quest.uri);
        memmove(temp, temp + 1, strlen(temp));
        char *uri_pointer = temp;
        memset(quest.methodname, '\0', sizeof(quest.methodname));
        switch (cases) {
        //PUT request
        case 1: {
            strcpy(quest.methodname, "PUT");
            int is_file = 0;
            int o;
            o = open(uri_pointer, O_WRONLY | O_TRUNC);
            if (o > 0) { //File exists
                is_file = 1;
            } else if ((o = creat(uri_pointer, O_WRONLY | S_IRWXU))
                       > 0) { //file dne, create new one
                is_file = 2;
            } else if (access(uri_pointer, R_OK | W_OK)) { //file is forbidden
                send(connfd, nf, strlen(nf), 0);
                close(connfd);
                quest.status_code = 404;
                break;
            } else { //Internal Server Error
                send(connfd, se, strlen(se), 0);
                close(connfd);
                quest.status_code = 500;
                break;
            }

            if (quest.hf_content_leng > 0) {
                char *put_msg = strstr(buffer, "\r\n\r\n");
                strncat(put_msg, "\0", 1);
                for (int i = 0; i < BUF_SIZE; i++) {
                }
                put_msg += 4; //account for \r\n\r\n
                int put_write = 0;
                put_write = quest.hf_content_leng;
                //printf("content: %d\n",quest.hf_content_leng);
                //fflush(stdout);
                //printf("reads: %d\n",reads);
                //fflush(stdout);
                int content_leng = 0;
                if (quest.hf_content_leng <= reads) {
                    content_leng = quest.hf_content_leng;
                } else {
                    content_leng = reads - quest.request_line_leng;
                    //printf("reads: %d\n reads-content_leng: %d\n",reads, content_leng);
                }

                //write message in current buffer (1st loop)
                int put_buf = 0;
                //printf("content_leng: %d\n",content_leng);
                //printf("put_msg: %s\n",put_msg);
                if ((put_buf = write(o, put_msg, content_leng)) < 0) {
                    write(connfd, se, strlen(se));
                    quest.status_code = 500;
                    break;
                }
                //printf("put_writeb4: %d\n",put_write);
                //printf("put_buf: %d\n",put_buf);
                put_write -= put_buf;
                //printf("put_writeaf: %d\n",put_write);
                //fflush(stdout);
                //message_body extends past buffer
                while (put_write > 0) {
                    printf("writing2\n");
                    if ((reads = read(connfd, buffer, BUF_SIZE)) < 0) {
                        write(connfd, se, strlen(se));
                        quest.status_code = 500;
                        break;
                    }

                    if ((put_buf = write(o, buffer, reads)) < 0) {
                        write(connfd, se, strlen(se));
                        quest.status_code = 500;
                        break;
                    }
                    put_write -= put_buf;
                }
            }
            close(o);
            if (is_file == 1) {
                send(connfd, ok, strlen(ok), 0);
                quest.status_code = 200;

            } else {
                send(connfd, cd, strlen(cd), 0);
                quest.status_code = 201;
            }
            close(connfd);
            break;
        }

        //APPEND request
        case 2: {
            strcpy(quest.methodname, "APPEND");
            int o = 0;
            struct stat sb;
            int isDir = 0;
            if (stat(uri_pointer, &sb) == 0) {
                isDir = S_ISDIR(sb.st_mode);
            }
            if (access(uri_pointer, F_OK)) { //check if file exists
                send(connfd, nf, strlen(nf), 0);
                quest.status_code = 404;
                close(connfd);
                break;
            } else if (access(uri_pointer, R_OK | W_OK) || isDir) { //check if file is forbidden
                send(connfd, nf, strlen(nf), 0);
                quest.status_code = 404;
                close(connfd);
                break;
            } else if ((o = open(uri_pointer, O_RDWR | O_APPEND)) > 0) {

                //case 1: content_length == 0;
                if (quest.hf_content_leng == 0) {
                    send(connfd, ok, strlen(ok), 0);
                    close(o);
                    close(connfd);
                    quest.status_code = 200;
                    break;
                }
                //case 2: content_length <= message_body size
                if (quest.hf_content_leng > 0) {
                    char *append_msg = strstr(buffer, "\r\n\r\n");
                    strncat(append_msg, "\0", 1);
                    append_msg += 4; //account for \r\n\r\n
                    //printf("append_msg: %s\n", append_msg);

                    int append_write = 0;
                    append_write = quest.hf_content_leng;
                    int content_leng = 0;
                    if (quest.hf_content_leng <= reads) {
                        content_leng = quest.hf_content_leng;
                    } else {
                        content_leng = reads - quest.request_line_leng;
                    }

                    //write message in current buffer (1st loop)
                    int append_buf = 0;
                    if ((append_buf = write(o, append_msg, content_leng)) < 0) {
                        write(connfd, se, strlen(se));
                        quest.status_code = 500;
                        break;
                    }
                    append_write -= append_buf;

                    //message_body extends past buffer
                    while (append_write > 0) {
                        if ((reads = read(connfd, buffer, BUF_SIZE)) < 0) {
                            write(connfd, se, strlen(se));
                            quest.status_code = 500;
                            break;
                        }

                        if ((append_buf = write(o, buffer, reads)) < 0) {
                            write(connfd, se, strlen(se));
                            quest.status_code = 500;
                            break;
                        }
                        append_write -= append_buf;
                    }
                }
                close(o);
                send(connfd, ok, strlen(ok), 0);
                quest.status_code = 200;
            } else { //Internal Server Error
                send(connfd, se, strlen(se), 0);
                close(connfd);
                quest.status_code = 500;
            }

            break;
        }
        //Get request
        case 3: {
            strcpy(quest.methodname, "GET");
            struct stat sb;
            int isDir = 0;

            if (stat(uri_pointer, &sb) == 0) {
                isDir = S_ISDIR(sb.st_mode);
            }
            if (access(uri_pointer, F_OK)) { //check if file exists
                send(connfd, nf, strlen(nf), 0);
                close(connfd);
                quest.status_code = 404;
                break;
            } else if (access(uri_pointer, R_OK | W_OK) || isDir) { //check if file is forbidden
                send(connfd, nf, strlen(nf), 0);
                close(connfd);
                quest.status_code = 404;
                break;
            } else if (isDir == 0) {
                int o = open(uri_pointer, O_RDONLY);
                if (o < 0) {
                    send(connfd, se, strlen(se), 0);
                    close(o);
                    break;
                }
                char response[buf];
                fstat(o, &sb);
                sprintf(response, "HTTP/1.1 200 OK\r\nContent-Length: %ld\r\n\r\n", sb.st_size);
                close(o);
                send(connfd, response, strlen(response), 0);
                quest.status_code = 200;
                FILE *getptr = NULL;
                getptr = fopen(uri_pointer, "r");
                char *getbuffer;
                if ((getbuffer = malloc(sb.st_size)) == 0) {
                    quest.status_code = 500;
                    send(connfd, se, strlen(se), 0);
                    close(connfd);
                    fclose(getptr);
                    free(getbuffer);
                    break;
                }
                size_t getresult;
                getresult = fread(getbuffer, 1, sb.st_size, getptr);
                send(connfd, getbuffer, sb.st_size, 0);
                free(getbuffer);
                fclose(getptr);
                close(connfd);
            } else {
                send(connfd, se, strlen(se), 0);
                close(connfd);
                quest.status_code = 500;
            }
            break;
        }
        }

        LOG("%s,%s,%d,%d\n", quest.methodname, quest.uri, quest.status_code, quest.hf_request_id);
        fflush(logfile);
    }
    free(buffer);
    free(tempbuff);
}

void add_node_connection(int connfd, pthread_mutex_t *p_mutex, pthread_cond_t *p_cond) {
    pthread_mutex_lock(p_mutex);
    enter(&pool.work, connfd);
    //pool.wait++;
    pthread_cond_signal(p_cond);
    pthread_mutex_unlock(p_mutex);
    sem_wait(&pool.semaphore);
}

void destroy_thread() {
    pool.isActive = 0;
    for (int i = 0; i < pool.t_count; i++) {
        pthread_cond_signal(&pool.condition);
    }

    for (int i = 0; i < pool.t_count; i++) {
        pthread_join(pool.pool[i], NULL);
    }
    free(pool.pool);
    free_node(&pool.work);
}
/*
static void sigterm_handler(int sig) {
    if (sig == SIGTERM || sig == SIGINT) {
        run = false;
        warnx("\nreceived SIGTERM\n");
        fflush(stdout);
        fclose(logfile);
        exit(EXIT_SUCCESS);
    }
}
*/
void term() {
    run = 1;
}
void *handle_thread() {
    while (pool.isActive == 1) {
        int worker = -1;
        //printf("work");
        pthread_mutex_lock(&pool.lock);
        worker = leave(&pool.work);
        if (worker == -1) {
            pthread_cond_wait(&pool.condition, &pool.lock);
            worker = leave(&pool.work);
        }
        pthread_mutex_unlock(&pool.lock);
        if (worker != -1) {
            handle_connection(worker);
            sem_post(&pool.semaphore);
        }
        //printf("worker: %d\n", worker);
    }
    return NULL;
}
void create_thread() {
    for (int i = 0; i < pool.t_count; i++) {
        pthread_create(&pool.pool[i], NULL, handle_thread, NULL);
        //printf("i: %d\n", i);
    }
}

void initialize_pool() {
    pool.isActive = 1;
    pool.condition = (pthread_cond_t) PTHREAD_COND_INITIALIZER;
    pool.lock = (pthread_mutex_t) PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
    //pool.wait = 0;
    pool.t_count = threads;
    pool.pool = (pthread_t *) malloc(sizeof(pthread_t[pool.t_count]));
    pool.work = NULL;
}
/*
    int t_count;
    int isActive;
    struct node *work;
    pthread_t *pool;
    pthread_mutex_t lock;
    pthread_cond_t condition;
    sem_t semaphore;
    int wait;
*/

int main(int argc, char *argv[]) {
    int opt = 0;
    threads = DEFAULT_THREAD_COUNT;
    logfile = stderr;
    while ((opt = getopt(argc, argv, OPTIONS)) != -1) {
        switch (opt) {
        case 't':
            threads = strtol(optarg, NULL, 10);
            if (threads <= 0) {
                errx(EXIT_FAILURE, "bad number of threads");
            }
            break;
        case 'l':
            logfile = fopen(optarg, "w");
            if (!logfile) {
                errx(EXIT_FAILURE, "bad logfile");
            }
            break;
        default: usage(argv[0]); return EXIT_FAILURE;
        }
    }
    if (optind >= argc) {
        warnx("wrong number of arguments");
        usage(argv[0]);
        return EXIT_FAILURE;
    }
    uint16_t port = strtouint16(argv[optind]);
    if (port == 0) {
        errx(EXIT_FAILURE, "bad port number: %s", argv[1]);
    }
    signal(SIGPIPE, SIG_IGN);
    //signal(SIGTERM, sigterm_handler);
    //signal(SIGINT, sigterm_handler);
    struct sigaction act;
    memset(&act, 0, sizeof(struct sigaction));
    act.sa_handler = term;
    sigaction(SIGTERM, &act, NULL);
    sigaction(SIGINT, &act, NULL);
    initialize_pool();
    create_thread();
    //printf("t_count: %d\n", pool.t_count);
    //printf("isActive: %d\n", pool.isActive);
    //printf("sizeof thread: %lu\n", sizeof(pool.pool));
    sem_init(&pool.semaphore, 0, threads);

    struct epoll_event ev;
    struct epoll_event *evs;

    int efd = -1;
    int nonblockfd = -1;
    int error_check = -1;

    nonblockfd = create_listen_socket(port); //create a listener socket
    error_check = non_block_socket(nonblockfd); //make the listener socket non blocking
    if (error_check != 0) {
        err(EXIT_FAILURE, "nonblocksocket failure\n");
    }
    efd = epoll_create1(0); //initialize epoll with max sockets
    if (efd == -1) {
        err(EXIT_FAILURE, "epoll_create error\n");
    }
    ev.data.fd = nonblockfd; //set struct epoll_event ev = nonblockfd
    ev.events = EPOLLIN | EPOLLET; //set flag for ev events

    if ((error_check = epoll_ctl(efd, EPOLL_CTL_ADD, nonblockfd, &ev))
        == -1) { //control interface to
        err(EXIT_FAILURE, "epoll_ctl error\n");
    }
    evs = calloc(MAXEVENTS, sizeof(ev)); //buffer where events get returned
    //test
    while (!run) {
        int i;
        int j;

        j = epoll_wait(efd, evs, MAXEVENTS, -1); //blocks until events are ready
        for (i = 0; i < j; i++) {
            if ((evs[i].events & EPOLLERR) || (evs[i].events & EPOLLHUP)
                || !(evs[i].events & EPOLLIN)) {
                //socket not ready or an error happened
                close(evs[i].data.fd);
                warnx("epoll error\n");
                continue;
            } else if (nonblockfd == evs[i].data.fd) {
                //one or more incoming connection coming from listening socket
                while (!run) {
                    struct sockaddr client_in;
                    socklen_t client_leng;
                    int client_fd;
                    client_leng = sizeof(client_in);
                    client_fd = accept(nonblockfd, &client_in, &client_leng);
                    if (client_fd == -1) {
                        if ((errno == EAGAIN) || (errno == EWOULDBLOCK)) { //processed all incoming connections, break while loop
                            break;
                        }
                        warnx("accept error\n");
                        break;
                    }
                    //make connection non-blocking and add it into evs to be monitored
                    non_block_socket(client_fd);
                    ev.data.fd = 0;
                    ev.data.fd = client_fd;
                    ev.events = EPOLLIN | EPOLLET;
                    error_check = epoll_ctl(efd, EPOLL_CTL_ADD, client_fd, &ev);
                    if (error_check != 0) {
                        err(EXIT_FAILURE, "epoll_ctl loop err\n");
                    }
                }
                continue;
            } else {
                //data from listener waiting to be added into multithread
                add_node_connection(evs[i].data.fd, &pool.lock, &pool.condition);
            }
        }
        /*
        int connfd = accept(listenfd, NULL, NULL);
        if (connfd < 0) {
            warn("accept error");
            continue;
        }
        
        add_node_connection(connfd, &pool.lock, &pool.condition);
        */
    }
    //printf("\nAHH\n");
    //fflush(stdout)
    free(evs);
    destroy_thread();
    printf("done.\n");
    return EXIT_SUCCESS;
}

static int create_listen_socket(uint16_t port) {
    struct sockaddr_in addr;
    int listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenfd < 0) {
        err(EXIT_FAILURE, "socket error");
    }
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htons(INADDR_ANY);
    addr.sin_port = htons(port);
    if (bind(listenfd, (struct sockaddr *) &addr, sizeof addr) < 0) {
        err(EXIT_FAILURE, "bind error");
    }
    if (listen(listenfd, 128) < 0) {
        err(EXIT_FAILURE, "listen error");
    }
    return listenfd;
}

static int non_block_socket(uint16_t port) {
    int flags = -1;
    int set = -1;

    flags = fcntl(port, F_GETFL, 0);
    if (flags == -1) {
        err(EXIT_FAILURE, "flag fcntl error");
    }
    flags |= O_NONBLOCK;
    set = fcntl(port, F_SETFL, flags);
    if (set == -1) {
        err(EXIT_FAILURE, "set fcntl error");
    }
    return 0;
}
