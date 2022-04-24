#! /usr/bin/python3

"""
This is an example Flask | Python | Psycopg2 | PostgreSQL
application that connects to the 7dbs database from Chapter 2 of
_Seven Databases in Seven Weeks Second Edition_
by Luc Perkins with Eric Redmond and Jim R. Wilson.
The CSC 315 Virtual Machine is assumed.

John DeGood
degoodj@tcnj.edu
The College of New Jersey
Spring 2020

----

One-Time Installation

You must perform this one-time installation in the CSC 315 VM:

# install python pip and psycopg2 packages
sudo pacman -Syu
sudo pacman -S python-pip python-psycopg2

# install flask
pip install flask

----

Usage

To run the Flask application, simply execute:

export FLASK_APP=app.py 
flask run
# then browse to http://127.0.0.1:5000/

----

References

Flask documentation:  
https://flask.palletsprojects.com/  

Psycopg documentation:
https://www.psycopg.org/

This example code is derived from:
https://www.postgresqltutorial.com/postgresql-python/
https://scoutapm.com/blog/python-flask-tutorial-getting-started-with-flask
https://www.geeksforgeeks.org/python-using-for-loop-in-flask/
"""

import psycopg2
from config import config
from flask import Flask, render_template, request

# Connect to the PostgreSQL database server
def connect(query):
    conn = None
    try:
        # read connection parameters
        params = config()
 
        # connect to the PostgreSQL server
        print('Connecting to the %s database...' % (params['database']))
        conn = psycopg2.connect(**params)
        print('Connected.')
      
        # create a cursor
        cur = conn.cursor()
        
        # execute a query using fetchall()
        cur.execute(query)
        rows = cur.fetchall()

        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
    # return the query result from fetchall()
    return rows
 
# app.py
app = Flask(__name__)


# serve form web page
@app.route("/")
def form():
    return render_template('home.html')

@app.route("/question1")
def question1():
    return render_template('question-1.html')

@app.route("/question2")
def question2():
    return render_template('question-2.html')

# handle venue POST and serve result web page
@app.route('/venue-handler', methods=['POST'])
def venue_handler(): # request.form(variable name from question 1 or question 2)
    #rows = connect('SELECT portfolio_manager_id, name FROM BUILDING WHERE portfolio_manager_id = ' + request.form['portfolio_manager_id'] + ';')
    #rows = connect('SELECT * FROM YEAR_METER_COST WHERE meter_type IN ' + request.form.getlist('Meter_Type') + ';')
    checkboxes = request.form.getlist('Meter_Type')
    size = len(checkboxes)
    index = 0
    checkbox_string = "("
    for checkbox in checkboxes:
        index += 1
        if index == size:
            checkbox_string = checkbox_string + '\'' + checkbox + '\''
        else:
            checkbox_string = checkbox_string + '\'' + checkbox + '\'' + ',' 
    checkbox_string += ")"
    rows = connect('SELECT CAST(date_part AS varchar(4)), meter_type, usage_amount, kbtupercost FROM YEAR_METER_COST WHERE meter_type IN ' + checkbox_string + ' AND ' + 'date_part BETWEEN ' + request.form['yearSel_startyear'] + ' AND ' + request.form['yearSel_endyear'] + ';')
    heads = ['Date', 'Meter Type', 'Usage Amount', 'Kbtu/Cost']

    meter_rows = connect('SELECT CAST(date_part AS varchar(4)), sum, usage_amount, kbtupercost FROM YEAR_ENERGY_SOURCE_KBTU_COST WHERE date_part BETWEEN ' + request.form['yearSel_startyear'] + ' AND ' + request.form['yearSel_endyear'] + ';')
    meters = ['Date', 'Total Cost', 'Usage Amount', 'Kbtu/Cost']
    return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meters=meters)

# handle query POST and serve result web page
@app.route('/query-handler', methods=['POST'])
def query_handler():
    rows = connect(request.form['query'])
    return render_template('my-result.html', rows=rows)

if __name__ == '__main__':
    app.run(debug = True)
