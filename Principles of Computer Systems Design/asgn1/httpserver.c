#include <assert.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctype.h>
#define buf     4096
#define urisize 19
extern int errno;
/**
   Converts a string to an 16 bits unsigned integer.
   Returns 0 if the string is malformed or out of the range.
 */
uint16_t strtouint16(char number[]) {
    char *last;
    long num = strtol(number, &last, 10);
    if (num <= 0 || num > UINT16_MAX || *last != '\0') {
        return 0;
    }
    return num;
}
/**
   Creates a socket for listening for connections.
   Closes the program and prints an error message on error.
 */
int create_listen_socket(uint16_t port) {
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
    if (listen(listenfd, 500) < 0) {
        err(EXIT_FAILURE, "listen error");
    }
    return listenfd;
}
struct request { //struct request stores connfd stuffs into its corresponding data sets
    char method[buf]; //for method
    char uri[buf]; //for uri
    char version[buf]; //for version of HTTP/#.#
    int isvalid_version; //0 = valid, -1 = invalid
    int isvalid_method;
    int isvalid_uri;
    char *message_body;
    int headerfield_count; //holds # of headerfields
    int hf_content_leng; //if request has content_leng key, store the value here
    int has_content_leng; //if request has a content_leng, = 1, else NULL
    int has_message_body; //if request has a message_body, = 1, else NULL
    char *header_field[]; //stores header_field
};
//Bad Implementation: -1
//Not Implemented: 0
//PUT: 1
//APPEND: 2
//GET: 3
int isValidMethod(struct request *quest) {
    if (strlen(quest->method) > 8) {
        return -1;
    } else if (strncmp(quest->method, "PUT", strlen(quest->method)) == 0) {
        return 1;
    } else if (strncmp(quest->method, "APPEND", strlen(quest->method)) == 0) {
        return 2;
    } else if (strncmp(quest->method, "GET", strlen(quest->method)) == 0) {
        return 3;
    } else {
        return 0;
    }
}
//Bad Implementation: -1
int isValidVersion(struct request *quest) {
    if ((strcmp(quest->version, "HTTP/1.1")) == 0) {
        return 0;
    } else {
        return -1;
    }
}
//Bad Implementation: -1
int isValidURI(struct request *quest) {
    if (strlen(quest->uri) > urisize || (quest->uri[0] != '/')) {
        return -1;
    }
    for (int i = 1; i < (int) strlen(quest->uri); i++) {
        if (!isalnum(quest->uri[i]) && quest->uri[i] != '.' && quest->uri[i] != '_') {
            return -1;
        }
    }
    return 0;
}
//calls the functions isValidMethod, isValidURI, isValidVersion
int handle_request_line(struct request *quest) {
    quest->isvalid_method = isValidMethod(quest);
    if (quest->isvalid_method == -1) {
        return -1;
    }
    quest->isvalid_version = isValidVersion(quest);
    if (quest->isvalid_version == -1) {
        return -1;
    }
    quest->isvalid_uri = isValidURI(quest);
    if (quest->isvalid_uri == -1) {
        return -1;
    }
    return quest->isvalid_method;
}
int handle_header_fields_message_body(struct request *quest, char *buffer) {
    quest->message_body = buffer;
    quest->message_body = strstr(quest->message_body, "\r\n\r\n");
    //another if statement to strstr to check if there is a message body
    if (quest->message_body == NULL) {
        quest->has_message_body = -1;
        if (quest->isvalid_method == 1 || quest->isvalid_method == 2) {
            return -1; //Bad Implementation
        }
    } else {
        quest->message_body = strtok(quest->message_body, "\r\n\r\n");
        quest->has_message_body = 0;
    }
    //printf("buffer: %s\n", buffer);
    int count = 0;
    char *tok = 0;
    char *tempmsg = strstr(buffer, "\r\n\r\n"); //pointer to end of the header_field
    if (tempmsg) {
        tok = malloc(
            (tempmsg - buffer) + 1); //malloc header_field space (end of header - buffer) + 1
        if (tok) {
            memcpy(tok, buffer,
                tempmsg
                    - buffer); //copy buffer header_field to tok with space(end of header - buffer)
            tok[tempmsg - buffer] = 0; //set NULL terminate at \r\n
            //printf("tok: %s\n",tok);
            char *temptok = strtok(tok, "\r\n"); //set point to tok
            //printf("temptok: %s\n", temptok);
            while (temptok != NULL) {
                quest->header_field[count] = temptok;
                //printf("quest->header_field[%d]: %s\n", count, quest->header_field[count]);
                //printf("test_tok_inloop: %s\n", temptok);
                char *validkey = 0;
                char *checkcolon = strstr(temptok, ":");
                if (checkcolon) {
                    validkey = malloc((checkcolon - temptok) + 1);
                    if (validkey) {
                        memcpy(validkey, temptok,
                            checkcolon - temptok); //copy header_field key: into validkey
                    }
                    if (strlen(validkey) == 0) {
                        return -1;
                    }
                }
                free(validkey);
                //printf("CHECKCOLON: %s\n",checkcolon);
                if (checkcolon
                    != NULL) { //every loop, checks the header_field to see if there is a ": denoting key:value"
                    for (size_t i = 0; i < strlen(temptok); i++) {
                        if (temptok[i] == ' ' || temptok[i] == 32) {
                            //printf("AH\n");
                            return -1; //Bad Implementation, there is white space between key and :
                        }
                        if (temptok[i] == ':' || temptok[i] == 58) {
                            //printf("CHECKED\n");
                            i = strlen(temptok);
                        }
                    }
                }

                char *checkContent_Length_size
                    = strstr(quest->header_field[count], "Content-Length: "); //check content_length
                //printf("checkContent_length: %s\n",checkContent_Length_size);
                if (checkContent_Length_size != NULL) { //sscanf for key: Content-Length
                    if (sscanf(
                            checkContent_Length_size, "Content-Length: %d", &quest->hf_content_leng)
                        == 1) {
                        quest->has_content_leng = 0;
                        //printf("quest->hf_content_leng: %d\n", quest->hf_content_leng);
                    } else {
                        return -1; //Bad Implementation, there is no count for content_leng
                    }
                }
                temptok = strtok(NULL, "\r\n");
                count++;
            }
            free(tok);
        }
    }
    //printf("count: %d\n", count);
    //printf("questmessage_body: %s\n", quest->message_body);
    quest->headerfield_count = count;
    return quest->isvalid_method;
}
//handles the checks for request_line, header_fields, message_body
int handle_protocol(struct request *quest, char *buffer) {
    char *saveptr;
    char *tok = strtok_r(buffer, "\r\n", &saveptr); //delimits
    if (sscanf(tok, "%s %s %s", quest->method, quest->uri, quest->version) != 3) {
        return -1;
    }

    int check = handle_request_line(quest);
    if (check == -1) {
        return -1;
    }
    check = handle_header_fields_message_body(quest, saveptr);
    if (check == -1) {
        return -1;
    }
    return check;
}

void handle_connection(int connfd) {
    //create variables
    char buffer[buf];
    struct request quest;
    char tempbuff[buf];
    //HTTP Responses

    char ok[] = "HTTP/1.1 200 OK\r\nContent-Length: 3\r\n\r\nOK\n";
    char cd[] = "HTTP/1.1 201 Created\r\nContent-Length: 8\r\n\r\nCreated\n";
    char br[] = "HTTP/1.1 400 Bad Request\r\nContent-Length: 12\r\n\r\nBad Request\n";
    char fn[] = "HTTP/1.1 403 Forbidden\r\nContent-Length: 10\r\n\r\nForbidden\n";
    char nf[] = "HTTP/1.1 404 Not Found\r\nContent-Length: 10\r\n\r\nNot Found\n";
    char se[]
        = "HTTP/1.1 500 Internal Server Error\r\nContent-Length: 22\r\n\r\nInternal Server Error\n";
    char ni[] = "HTTP/1.1 501 Not Implemented\r\nContent-Length: 16\r\n\r\nNot Implemented\n";
    if (recv(connfd, buffer, buf, 0) > 0) {
        strcpy(tempbuff, buffer); //copy buffer values into tempbuff
        //printf("tempbuff: %s", tempbuff);
        int cases = handle_protocol(&quest, tempbuff);
        char temp[buf];
        memset(temp, '\0', sizeof(temp));
        strcpy(temp, quest.uri);
        memmove(temp, temp + 1, strlen(temp));
        char *uri_pointer = temp;

        switch (cases) {
            //Bad Request
        case -1: {
            send(connfd, br, strlen(br), 0);
            close(connfd);
            return;
        }

        //Not Implemented
        case 0: {
            send(connfd, ni, strlen(ni), 0);
            close(connfd);
            return;
        }
        //PUT request
        case 1: {
            int is_file = 0;
            int o;
            if ((o = open(uri_pointer, O_WRONLY | O_TRUNC)) > 0) { //File exists
                is_file = 1;
            } else if ((o = creat(uri_pointer, O_WRONLY | S_IRWXU))
                       > 0) { //file dne, create new one
                is_file = 2;
            } else if (access(uri_pointer, R_OK | W_OK)) { //file is forbidden
                send(connfd, fn, strlen(fn), 0);
                close(connfd);
                return;
            } else { //Internal Server Error
                send(connfd, se, strlen(se), 0);
                close(connfd);
                return;
            }
            int putnum;
            int bytesize = 0;
            char reading[1000000];
            while (1) {
                if (bytesize == quest.hf_content_leng) {
                    break;
                }
                putnum = recv(connfd, reading, 1000000, 0);
                write(o, reading, putnum);
                bytesize = bytesize + putnum;
            }
            close(o);
            if (is_file == 1) {
                send(connfd, ok, strlen(ok), 0);
            } else {
                send(connfd, cd, strlen(cd), 0);
            }
            close(connfd);
            return;
        }
        //APPEND request
        case 2: {
            int o;
            struct stat sb;
            int isDir = 0;
            if (quest.has_content_leng == -1) {
                send(connfd, br, strlen(br), 0);
                close(connfd);
                return;
            }
            if (stat(uri_pointer, &sb) == 0) {
                isDir = S_ISDIR(sb.st_mode);
            }
            if (access(uri_pointer, F_OK)) { //check if file exists
                send(connfd, nf, strlen(nf), 0);
                close(connfd);
                return;
            } else if (access(uri_pointer, R_OK | W_OK) || isDir) { //check if file is forbidden
                send(connfd, fn, strlen(fn), 0);
                close(connfd);
                return;
            } else if ((o = open(uri_pointer, O_RDWR | O_APPEND)) > 0) {
                int bytesize = 0;
                int finishwrite = 1;
                //case 1: content_length == 0;
                if (quest.hf_content_leng == 0) {
                    send(connfd, ok, strlen(ok), 0);
                    close(o);
                    close(connfd);
                    return;
                }
                //case 2: content_length <= message_body size
                if (quest.hf_content_leng <= (int) strlen(quest.message_body)) {

                    while (1) {
                        if (bytesize >= quest.hf_content_leng || finishwrite == 0) {
                            break;
                        }
                        //printf("Message_body: %s\n",quest.message_body);
                        //printf("strlenmes: %lu\n",strlen(quest.message_body));
                        finishwrite = write(o, quest.message_body, quest.hf_content_leng);
                        bytesize += quest.hf_content_leng;
                        quest.hf_content_leng -= bytesize;
                    }
                } else {
                    write(o, quest.message_body, (int) strlen(quest.message_body));
                }
                //case 3: content_length > message_body size
                close(o);
                send(connfd, ok, strlen(ok), 0);
            } else { //Internal Server Error
                send(connfd, se, strlen(se), 0);
                close(connfd);
                return;
            }
            close(connfd);
            return;
        }
        //Get request
        case 3: {

            struct stat sb;
            int isDir = 0;

            if (stat(uri_pointer, &sb) == 0) {
                isDir = S_ISDIR(sb.st_mode);
            }
            if (access(uri_pointer, F_OK)) { //check if file exists
                send(connfd, nf, strlen(nf), 0);
                close(connfd);
                return;
            } else if (access(uri_pointer, R_OK | W_OK) || isDir) { //check if file is forbidden
                send(connfd, fn, strlen(fn), 0);
                close(connfd);
                return;
            }
            int getnum;
            int o = open(uri_pointer, O_RDONLY);
            char response[buf];
            char reading[1000000];

            fstat(o, &sb);
            sprintf(response, "HTTP/1.1 200 OK\r\nContent-Length: %ld\r\n\r\n", sb.st_size);
            send(connfd, response, strlen(response), 0);
            while (1) {
                getnum = read(o, reading, 1000000);
                send(connfd, reading, getnum, 0);
                if (getnum == 0) {
                    break;
                }
            }
            close(o);
            close(connfd);
            return;
        }
        }
    }
}

int main(int argc, char *argv[]) {
    int listenfd;
    uint16_t port;
    if (argc != 2) {
        errx(EXIT_FAILURE, "wrong arguments: %s port_num", argv[0]);
    }
    port = strtouint16(argv[1]);
    if (port == 0) {
        errx(EXIT_FAILURE, "invalid port number: %s", argv[1]);
    }
    listenfd = create_listen_socket(port);
    signal(SIGPIPE, SIG_IGN);
    while (1) {
        int connfd = accept(listenfd, NULL, NULL);
        if (connfd < 0) {
            warn("accept error");
            continue;
        }
        handle_connection(connfd);
    }
    return EXIT_SUCCESS;
}
