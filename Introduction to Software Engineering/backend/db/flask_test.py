#from flask import Flask, request,render_template
import psycopg2
try: 
    conn = psycopg2.connect("dbname='db_acdemic' user='postgres' host='0.0.0.0' password='password1' port='5432'")
    print("connected")
except:
    print ("I am unable to connect to the database")

mycursor = conn.cursor()


#app = Flask(__name__)
mycursor.execute("SELECT * FROM Course")
data = mycursor.fetchall()
for row in data:
    print(row)
    print('\n')


mycursor.execute("SELECT * FROM curriculum")
data = mycursor.fetchall()
for row in data:
    print(row)
    print('\n')