# UCSC Academic Helper
# db_client.py
# Creation 07/02/22 13:12
# Revision 0
# ---------------------------------------------------------------------------------------
# Module to facilate database connection and manipulation.
# ---------------------------------------------------------------------------------------

import psycopg2
import logging
import re
import typing


class db_data:
    def __init__(self):
        self.classes = list()
        self.quali = list()
        self.req = list()
        self.preq = list()
        self.desc = list()
        self.condition = dict()
        self.ge = list()
        self.title = list()
        self.curriculum = ""

    # get all course from database
    # arguments: None
    # returns: tuple 'data' containing raw data from the database

    def query_course(self):
        # Establish connection with database
        try:
            conn = psycopg2.connect(
                "dbname='db_acdemic' user='postgres' host='0.0.0.0' password='password1' port='5432'"
            )
            logging.debug("Database Connected")
        except:
            logging.debug("Database Failed to Connect")

        # fetch data from db and store
        cursor = conn.cursor()

        cursor.execute("SELECT * FROM Course")
        data = cursor.fetchall()
        # close and reset db
        conn.close()
        return data

    # get all curriculum from database
    # arguments: None
    # returns: tuple 'data' containing raw data from the database

    def query_curriculum(self):
        # Establish connection with database
        try:
            conn = psycopg2.connect(
                "dbname='db_acdemic' user='postgres' host='0.0.0.0' password='password1' port='5432'"
            )
            logging.debug("Database Connected")
        except:
            logging.debug("Database Failed to Connect")

        # fetch data from db and store
        cursor = conn.cursor()

        cursor.execute("SELECT * FROM curriculum")
        data = cursor.fetchall()
        # close and reset db
        conn.close()
        return data

    def select_course_herlper(self, conditions, req, quali, preq, desc, ge, title, course_num, course_name):
            # selecting classes based on conditions
                # if list_all, then ignore all other conditions
            if conditions["List_all"] == True:
                self.classes.append(course_name)
                self.quali.append(quali)
                self.req.append(req)
                self.preq.append(preq)
                self.desc.append(desc)
                self.ge.append(ge)
                self.title.append(title)
                # not list_all, check division requirments first
            else:
                    # if query for lower div
                if conditions["Division"] == "low":
                    if course_num < 100:
                            # if Quali AND Req
                        if (
                            conditions["Quali"] == True
                            and conditions["Req"] == True
                        ):
                            if any(ele == conditions["Major"] for ele in quali) and any(
                                ele == conditions["Major"] for ele in req
                            ):
                                self.classes.append(course_name)
                                self.quali.append(quali)
                                self.req.append(req)
                                self.preq.append(preq)
                                self.desc.append(desc)
                                self.ge.append(ge)
                                self.title.append(title)
                            # if Quali Only
                        elif (
                            conditions["Quali"] == True
                            and conditions["Req"] == False
                        ):
                            if any(ele == conditions["Major"] for ele in quali):
                                self.classes.append(course_name)
                                self.quali.append(quali)
                                self.req.append(req)
                                self.preq.append(preq)
                                self.desc.append(desc)
                                self.ge.append(ge)
                                self.title.append(title)
                        # if Req Only
                        elif (
                            conditions["Quali"] == False
                            and conditions["Req"] == True
                        ):
                            if any(ele == conditions["Major"] for ele in req):
                                self.classes.append(course_name)
                                self.quali.append(quali)
                                self.req.append(req)
                                self.preq.append(preq)
                                self.desc.append(desc)
                                self.ge.append(ge)
                                self.title.append(title)
                # if query for higher div
                elif conditions["Division"] == "high":
                    if course_num >= 100:
                        # if Quali AND Req
                        if (
                            conditions["Quali"] == True
                            and conditions["Req"] == True
                        ):
                            if any(ele == conditions["Major"] for ele in quali) and any(
                                ele == conditions["Major"] for ele in req
                            ):
                                self.classes.append(course_name)
                                self.quali.append(quali)
                                self.req.append(req)
                                self.preq.append(preq)
                                self.desc.append(desc)
                                self.ge.append(ge)
                                self.title.append(title)
                            # if Quali Only
                        elif (
                            conditions["Quali"] == True
                            and conditions["Req"] == False
                        ):
                            if any(ele == conditions["Major"] for ele in quali):
                                self.classes.append(course_name)
                                self.quali.append(quali)
                                self.req.append(req)
                                self.preq.append(preq)
                                self.desc.append(desc)
                                self.ge.append(ge)
                                self.title.append(title)
                        # if Req Only
                        elif (
                            conditions["Quali"] == False
                            and conditions["Req"] == True
                        ):
                            if any(ele == conditions["Major"] for ele in req):
                                self.classes.append(course_name)
                                self.quali.append(quali)
                                self.req.append(req)
                                self.preq.append(preq)
                                self.desc.append(desc)
                                self.ge.append(ge)
                                self.title.append(title)
                # Not querying for particular div
                elif conditions["Division"] == None:
                    # if Quali AND Req
                    if conditions["Quali"] == True and conditions["Req"] == True:
                        if any(ele == conditions["Major"] for ele in quali) and any(
                            ele == conditions["Major"] for ele in req
                        ):
                            self.classes.append(course_name)
                            self.quali.append(quali)
                            self.req.append(req)
                            self.preq.append(preq)
                            self.desc.append(desc)
                            self.ge.append(ge)
                            self.title.append(title)
                    # if Quali Only
                    elif conditions["Quali"] == True and conditions["Req"] == False:
                        if any(ele == conditions["Major"] for ele in quali):
                            self.classes.append(course_name)
                            self.quali.append(quali)
                            self.req.append(req)
                            self.preq.append(preq)
                            self.desc.append(desc)
                            self.ge.append(ge)
                            self.title.append(title)
                    # if Req Only
                    elif conditions["Quali"] == False and conditions["Req"] == True:
                        if any(ele == conditions["Major"] for ele in req):
                            self.classes.append(course_name)
                            self.quali.append(quali)
                            self.req.append(req)
                            self.preq.append(preq)
                            self.desc.append(desc)
                            self.ge.append(ge)
                            self.title.append(title)
    # select classes from data, return all matching in a list
    # arguments: list 'conditions', tuple 'data'
    # returns: None, the calling object is updated during function call
    # condition format:
    # {Major, List_all, Division, Quali, Req}
    # Major: CS/EE/CE
    # List_all: true, false
    # Division: low, high, None
    # Quali: true, false
    # Req: true, false
    def select_course(self, conditions: dict, data: list):
        # temp list to return a list of classes later
        for each in data:
            # parse information about each class into their own var
            course_name = each[1]
            internal_dict = each[2]
            # remove the [] in string format and convert into python list
            req = internal_dict["major_req"]
            req = req.replace("[", "")
            req = req.replace("]", "")
            req = req.split(",")

            quali = internal_dict["major_quali"]
            quali = quali.replace("[", "")
            quali = quali.replace("]", "")
            quali = quali.split(",")

            preq = internal_dict["prereq_courses"]
            preq = preq.replace("[", "")
            preq = preq.replace("]", "")
            preq = preq.split(",")

            desc = internal_dict["description"]
            desc = desc.replace('"', "")

            ge = internal_dict["ge"]
            ge = ge.replace("[", "")
            ge = ge.replace("]", "")
            ge = ge.split()

            title = internal_dict["title"]
            title = title.replace('"', "")

            # parse class number
            course_num = re.findall("[0-9]+", course_name)
            course_num = int(course_num[0])

            # selecting classes based on conditions
            self.select_course_herlper(conditions, req, quali, preq, desc, ge, title, course_num, course_name)
        self.condition = conditions.copy()
        return

    # select curriculum from data, return the matching in a string
    # arguments: list 'conditions', tuple 'data'
    # returns: None, the calling object is updated during function call
    # condition format:
    # {Major}
    # Major: CS/EE/CE

    def select_curriculum(self, conditions: dict, data: list):

        for each in data:

            major = each[1]
            internal_dict = each[2]

            url = internal_dict["url"]
            url = url.replace('"', "")

            if conditions["Major"] == "CS":
                if major == "CS":
                    self.curriculum = url

            elif conditions["Major"] == "CE":
                if major == "CE":
                    self.curriculum = url

            elif conditions["Major"] == "EE":
                if major == "EE":
                    self.curriculum = url

        return
