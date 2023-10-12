Assignment 1
## Program Description
**Program ./httpserver {####}**
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
I used structs to hold the values and variables for incoming requests. the struct Request has multiple functions to handle various checks to see if the request is valid alongside holding flags for the multiple method cases as well.
### Functions:
####int isValidMethod(struct request *quest);
Checks the quest method to see if it corresponds to either PUT, APPEND, or GET. returns -1 if the method is greater than 8 characters. returns 1,2,3 to correspond with PUT, APPEND, or GET. returns 0 to correspond with an unimplemented method

####int isValidVersion(struct request *quest);
checks if the version is valid ie. must be HTTP/1.1
returns 0 if it's valid else returns -1 for bad implementation.

####int isValidURI(struct request *quest);
checks if the URI is less than 19, starts with "/", is alphanumeric alongside '.' && '_' characters.
Returns -1 if it does not follow that format for bad implementation.
Returns 0 if it follows the format.

####int handle_request_line(struct request *quest);
calls the methods listed above to check whether the request-line follows the formats provided by the pdf.
returns -1 for Bad Implementation
returns quest->isvalid_method to be used for cases

####int handle_header_fields_message_body(struct request *quest);
Delimits the header_fields and message_body to its corresponding chunks denoted by the separation of "\\r\\n". Checks if there is a message_body and compares it with the method as PUT and APPEND need a message_body while GET does not need it.
Loops through the header_fields to count the amount of header fields and checks if it is in the format (key: value). Also checks for a header_field: Content-Length: # to denote the amount of characters needed for methods PUT and APPEND.
returns -1 for Bad implementation
returns quest->isvalid_method for cases

####int handle_protocol(struct request *quest, char *buffer)
the main function called upon by void handle_connection. used to check formats of requests commands by calling handle_reuqest_line and handle_header_fields_message_body.
splits the buffer with the first "\\r\\n" to check the request-line: method uri version and stores it into the corresponding struct variables
returns -1 for Bad implementation
returns check which is simply quest->isvalid_method for cases  

####void handle_connection(int connfd);
Creates variables to be used for cases and instantiates a struct request quest. Calls handle_protocol and checks if it's a valid HTTP command goes through cases and sends the correct Response for each request.
#####Case 1: Bad Request
sends status-code 400 for Bad Request if the functions detect something wrong with the HTTP commands
#####Case 2: Not Implemented
sends status-code 501 for Not Implemented if the fucntions detected an unimplmeneted function from isValidMethod()

#####Case 3: PUT Request
opens the file correlated with URI and checks for if the file exists or does not exists. If it exists changes the flag = 1. If it does not exists flag = 2. Checks for case if the file is forbidden or sends an Internal Server Error status if switch:case does not open/create a file
While-Loop to put the message_body into the file
Sends status-code 200 for flag = 1 or status-code 201 for flag = 2

#####Case 4: Append Request
Checks if the file DNE or Forbidden. Sends status-code appropriate to those cases. If not sent, opens file and appends message_body to the amount given in content-length. Sends status-code 200

#####Case 5: Get Request
Checks if the file DNE or Forbidden or does not open. Sends status-code appropriate to those cases ie: 404, 403, 500. While-loop through the file to get the bytes and sends the data to the client side. Sends status-code 200 when done.
