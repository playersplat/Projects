## UCSC Academic Helper
## request_parser.py
## Creation 07/02/22 13:12
## Revision 0
## ---------------------------------------------------------------------------------------
## Module to parse frontend request and control of db_client
## ---------------------------------------------------------------------------------------
import json
from flask import request

# parse the request info from the header field
# input: rq the flask request object
# output: output a dict containing parsed conditions
def rq_parser(rq):
    output = {"Major": None, "Chart": None}
    output["Major"] = request.headers.get("Major")

    if request.headers.get("Chart") == "true":
        output["Chart"] = True
    else:
        output["Chart"] = False
        if request.headers.get("List_all") == "true":
            output["List_all"] = True
        elif request.headers.get("List_all") == "false":
            output["List_all"] = False
        output["Division"] = request.headers.get("Division")
        if request.headers.get("Quali") == "true":
            output["Quali"] = True
        elif request.headers.get("Quali") == "false":
            output["Quali"] = False
        if request.headers.get("Req") == "true":
            output["Req"] = True
        elif request.headers.get("Req") == "false":
            output["Req"] = False

    return output
