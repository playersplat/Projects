Assignment 2 Checkpoint 2
## Program Description
**Program ./httpserver -t <thread_num> -l <file foo> {####}**
**Client: METHOD URI HTTP (HEADER_FIELD), MESSAGE_BODY**
The program is an HTTP server that executes forever and waits for a client to send HTTP commands ie. GET, PUT, & APPEND. The HTTP server will process the HTTP command and send the client the correct response phrases.
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

static void handle_connection(int connfd)
void add_node_connection(int connfd, pthread_mutex_t *p_mutex, pthread_cond_t *p_cond)
whenever connfd gets received, calls add_node_connection and queues
the connfd into a linked list, lock and unlocks appropriately

void destroy_thread() {
stops threads from running
joins threads and frees them
frees linked list by calling free_node();
static void sigterm_handler(int sig)
provided by starter code

void *handle_thread() {
while loop that processes queue of requests (connfd)
locks thread when it handles a connection and unlocked when finished
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