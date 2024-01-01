# HTTP Service
HTTP web service application set to differentiate between requests with different HTTP verbs (GET and POST) alongside URI paths (/hello, /hello/<name>, and /test)

Packaged application into a docker container and set the service to listen to port 8090

#Building and testing
docker build -t httpserver.py
docker run --rm -p 8090:8090 httpserver.py

run test_assignment1.py to test functionalities

#Description of interfaces
##/hello
accepts a GET request (with no parameter) and returns the JSON response body {"message":"world"} alongside status code 200.

when sent a POST request, response status code is 405 alongside response Method Not Allowed

##/hello/<name>
accepts a POST request with the path-parameter "name". Responds with status code 200 {"message": "Hi, <name>"}

when sent a GET request, returns a status code 405 alongside response Method Not Allowed

##/test
accepts a GET request with no query parameters. Responds with status code 200 along with body {"message":"test is successful"}

accepts POST request with a msg query. Responds with status code 200 alongside {"message":"<msg>"}
when receiving a POST request with NO msg query. Responds with status code 400 with response as Bad Request

## Citations
https://docs.python.org/3.11/library/http.server.html
https://docs.python.org/3.11/library/http.server.html#http.server.BaseHTTPRequestHandler
https://docs.python.org/3.11/library/io.html#io.BufferedIOBase
https://docs.python.org/3.11/library/json.html


