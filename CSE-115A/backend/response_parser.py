## UCSC Academic Helper
## response_parser.py
## Creation 07/02/22 13:12
## Revision 0
## ---------------------------------------------------------------------------------------
## Module to parse database output and create response to frontend.
## ---------------------------------------------------------------------------------------

import json
import db_client


def response_parser(db_object: db_client.db_data):

    # return the url of the curriculum chart
    if len(db_object.curriculum) != 0:
        return db_object.curriculum
    # return the lists of classes
    else:
        QualiList = []
        ReqList = []
        PreqList = []
        DescList = []
        TitleList = []
        GeList = []

        DescDict = {}
        PreqDict = {}
        TitleDict = {}
        GeDict = {}

        for i in range(0, len(db_object.classes)):

            # add major qualification classes
            if db_object.quali[i]:
                QualiList.append(True)
            else:
                QualiList.append(False)

            # add major requirement classes
            if db_object.req[i]:
                ReqList.append(True)
            else:
                ReqList.append(False)

            # add prerequisites for each class
            if len(db_object.preq[i]) > 0:
                PreqDict[db_object.classes[i]] = db_object.preq[i]
                PreqList.append(db_object.preq[i])
            else:
                PreqDict[db_object.classes[i]] = []
                PreqList.append([])

            # add course description
            if db_object.desc[i]:
                DescList.append(db_object.desc[i])
                DescDict[db_object.classes[i]] = db_object.desc[i]
            else:
                DescList.append("")
                DescDict[db_object.classes[i]] = ""

            # add GE for each course
            if db_object.ge[i]:
                GeList.append(db_object.ge[i])
                GeDict[db_object.classes[i]] = db_object.ge[i]
            else:
                GeList.append("")
                GeDict[db_object.classes[i]] = ""

            # add course title
            if db_object.title[i]:
                TitleList.append(db_object.title[i])
                TitleDict[db_object.classes[i]] = db_object.title[i]
            else:
                TitleList.append("")
                TitleDict[db_object.classes[i]] = ""

        returnFile = {
            "Class": db_object.classes,
            "Quali": QualiList,
            "Req": ReqList,
            "Preq": PreqDict,
            "Desc": DescDict,
            "Title": TitleDict,
            "GE": GeDict,
            # "Title": TitleList,
            # "GE": GeList
            # "Preq": PreqList,
            # "Desc": DescList,
        }

        return json.dumps(returnFile)
