Assignment 4
## Program Description
**Program ./httpserver -t <thread_num> -l <file foo> {####}**
**Client: METHOD URI HTTP (HEADER_FIELD), MESSAGE_BODY**
The program is an HTTP server that executes forever and waits for a client to send HTTP commands ie. GET, PUT, & APPEND. The HTTP server will process the HTTP command and send the client the correct response phrases.
(Program able to process requests using an epoll/multithread system)
Using an edge-triggered epoll, it sets the connection to non-blocking and monitors it for new events everytime there is a new request in the event loop.
When the client either partial sends or finished sending a request, epoll adds that socket into add_node_connection()

I used a producer - multiple consumer type design for my dispatcher and worker threads. Everytime there is a new request, the main thread will try to 
take a lock to add the connection into my linked-list. else, it waits until the lock is released by one of the worker threads. Each worker thread shares the same lock in order to prevent threads from concurrently pulling from the linked-list of connections. When there is a request in the linked-list and my work thread is asleep and has nothing in it, the producer signals a condition variable to wake up one of the threads to pull from the queue. From there, the requests gets handled in handle_connection. Using flocks, the requests adheres to atomicity and coherency with the logfile and sending HTTP-Responses to the client.

Following format for HTTP Command:
Response-Line: METHOD, URI, HTTP VERSION.
  METHOD - case-sensitive command that is used to process into different cases.  
URI - format starts with / and is alphanumeric along with '.' and '_'. A uniform resource identifier for files and directories for the HTTPSERVER server to change/grab information
  VERSION - valid requests will include HTTP/1.1

Header-Field: (key: value)
  format key: value which is seperated with \\r\\n and commands can have 0 or more header-fields

Message-Body:
  PUT and APPEND requests require a message-body alongside with a header-field: Content-Length: # to use. It is not included in GET requests.
## Program Design
I used structs to hold the values and variables for incoming requests. the struct Request has multiple functions to handle various checks to see if the request is valid alongside holding flags for the multiple method cases as well. I refactored my code from asgn2 to deal with only four different status codes
provided by the assignment doc. Added mutex locks, conditionals, and semaphores to send connfd to a linked list and main() dispatcher assigns threads as needed.

### Functions:
static int isValidMethod(struct request *quest);
Checks the quest method to see if it corresponds to either PUT, APPEND, or GET. returns 1,2,3 to correspond with PUT, APPEND, or GET. else is considered an internal server error

static int handle_request_line(struct request *quest);
calls the methods listed above to check whether the request-line follows the formats provided by the pdf. (should as there are no bad requests for this asgn)
returns quest->isvalid_method to be used for cases

static int handle_header_fields_message_body(struct request *quest);
sscanf for Content-Length: # to denote the amount of characters needed for methods PUT and APPEND.
and Request-Id: # for appropriate log auditing
returns quest->isvalid_method for cases

static int handle_protocol(struct request *quest, char *buffer)
the main function called upon by void handle_connection. used to check formats of requests

void handle_connection(int connfd)
{
    initializes a request struct, receives data from socket
    uses handle_protocol to set up request struct with appropriate data for handling and sets its case
    case used in a switch statement to process the correct response
    case PUT:
        adheres to assignment documentation, returns appropriate response code
        either creates or truncates a file using uri
        puts the # of bytes corresponding to content-length: %d and flocks logfile for atomicity
    case APPEND
        adheres to assignment documentation, returns appropriate response code
        appends a file using uri, puts the # of bytes corresponding to content-length: %d and flocks logfile for atomicity
    case GET
        adheres to assignment documentation, returns appropriate response code
        gets the number of bytes in uri and responses with code 200 OK
        else respond with 404 (file not found) or 500 (internal server error) 
        flocks logfile for atomicity
    Request-Id: gets used for appropriate logging too.    
}


void destroy_thread() {
stops threads from running
joins threads and frees them
frees linked list by calling free_node();
static void sigterm_handler(int sig)
provided by starter code

void add_node_connection(int connfd, pthread_mutex_t *p_mutex, pthread_cond_t *p_cond) {
    acquires mutex lock,
    adds connection to linked list
    signal condition variable
    unlock mutex
}

void *handle_thread() {
while loop that processes queue of requests (connfd)
acquires mutex lock
pops connection from linked list
checks if connection is present or -1
if -1, thread condition waits until main thread gives signal that there is something in the queue
unlock mutex lock
if thread has a connection, handle the connection
void create_thread()
create # of worker threads given the amount inputed into terminal
else default is 4

void initialize_pool();
initializes thread pool struct and sets it to corresponding values
### ADT Function (linkedq.c || linkedq.h)

void enter(node **front, int x);
inputs a value of node with value x into linked list
int leave(node **front);
retrieves value from node with value x out of linked list
void free_node(node **front);
frees linked list