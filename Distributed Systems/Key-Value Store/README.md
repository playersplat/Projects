#Key-value Store
Part 1: Single-site Key-value store
supports adding a new key-value pair to the store, retrieving and updadting the value of an existing key, and deleting an existing key from the store
The store does not need to persist i.e., it can store data in memory only. If the store goes down and starts up again, it does not contain the data it had before the crash

Part 2: Key-value Store with proxies
Main role: Acts as the main instance of Key-value Store seen in Part 1, but can collect information forwarded to it from other instances
Forwarding role: A proxy instance that forwards each request to the main instance, gets a response from it, and returns the response to the client

#Building and testing
Run the entrypoint.sh to enable either main instance, forwarding instance, or both.

To test functionality of Key-value store parts 1 and 2, please use the provided test_assignment2_part1 || part2 python scripts
# Citations
https://pypi.org/project/requests/
https://docs.python.org/3/library/os.html
https://www.geeksforgeeks.org/use-jsonify-instead-of-json-dumps-in-flask/
https://www.warp.dev/terminus/dockerfile-run-sh
https://www.geeksforgeeks.org/flask-app-routing/
https://docs.docker.com/network/#published-ports

# Contributions
Brian Bui - Assignment 2 part 2 & 1, debugging, code review 
Monyreak Kit - Assignment 2 part 1 & 2, debugging, code review

General 50:50 contribution in assignment 2

