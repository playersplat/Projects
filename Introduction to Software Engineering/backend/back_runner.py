# UCSC Academic Helper
# runner.py
# Creation 07/02/22 13:12
# Revision 0
# ---------------------------------------------------------------------------------------
# Module to run and maintiance backend processes, maintian IO with frontend and database.
# ---------------------------------------------------------------------------------------
from audioop import cross
import os
from flask import Flask, request, render_template
from flask_cors import CORS, cross_origin
import request_parser
import response_parser
import db_client


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY="dev",
        DATABASE=os.path.join(app.instance_path, "flaskr.sqlite"),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile("config.py", silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # load the front page (Front.html)
    @app.route("/", methods=["GET"])
    def index():
        return render_template("Front.html")

    # just gonna keep it here for sanity
    # a simple page that says hello
    @app.route("/hello")
    def hello():
        return "Hello, World!"

    # yes it is genshin quote bite me
    @app.route("/idle")
    def idle():
        return "You seem... troubled. Traveler, do not lose heart! For with my left eye, the Auge der Verurteilung, which sees the threads of fate, I will surely keep you from harm. And Oz, the raven that has witnessed the demise of countless worlds, will watch over you on your journey. Should this world, like a beast prowling in the night, covet your dreams, then I, Prinzessin der Verurteilung, shall fell it with my ensorcelled arrows of judgment!"

    # execute the request parser.
    @app.route("/request", methods=["GET"])
    # @cross_origin
    def processor():
        print(request.headers)
        if request.method == "GET":
            # format incoming request
            formateted_con = request_parser.rq_parser(request)
            # create object to hold data
            data_obj = db_client.db_data()

            # query curriculum
            if formateted_con["Chart"] == True:
                raw_data_curriculum = data_obj.query_curriculum()
                data_obj.select_curriculum(formateted_con, raw_data_curriculum)
                response = response_parser.response_parser(data_obj)
                # return url
                return response
            # query course
            else:
                raw_data_courses = data_obj.query_course()
                data_obj.select_course(formateted_con, raw_data_courses)
                response = response_parser.response_parser(data_obj)
                # return formatted json
                return response

    return app


app = create_app()
cors = CORS(app)

if __name__ == "__main__":
    app.run(host="localhost", port=5001, debug=True)
