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
@app.route('/questionone_handler', methods=['POST'])
def questioneone_handler(): # request.form(variable name from question 1 or question 2)
    options = request.form['ENERGY_SOURCE_KBTU_COST']
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

    if (options == "YEAR_ENERGY_SOURCE_KBTU_COST"):
        rows = connect('SELECT year, cost, usage_amount, kbtupercost, meter_type FROM YEAR_ENERGY_SOURCE_KBTU_COST WHERE CAST(year AS int) BETWEEN ' + request.form['yearSel_startyear'] + ' AND ' + request.form['yearSel_endyear'] + ';')
        heads = ['Year', 'Total Cost', 'Usage Amount', 'Kbtu/Cost', 'Meter Type']
        meter_rows = ""
        meter_heads = ""

        if checkboxes and request.form.getlist('Meter_Cost'):
            meter_rows = connect('SELECT year, meter_type, cost FROM YEAR_METER_COST WHERE meter_type IN ' + checkbox_string + ' AND ' + 'CAST(year AS int) BETWEEN ' + request.form['yearSel_startyear'] + ' AND ' + request.form['yearSel_endyear'] + ';')
            meter_heads = ['year', 'Meter Type', 'Cost']

        return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meter_heads=meter_heads)
    elif (options == "MONTH_ENERGY_SOURCE_KBTU_COST"):
        rows = connect('SELECT year, month, cost, usage_amount, kbtupercost, meter_type FROM MONTH_ENERGY_SOURCE_KBTU_COST WHERE CAST(year AS int) = ' + request.form['monthSel_year'] + ' AND CAST(month AS int) BETWEEN ' + request.form['monthSel_startmonth'] + ' AND ' + request.form['monthSel_endmonth'] + ';')
        heads = ['Year', 'Month', 'Total Cost', 'Usage Amount', 'Kbtu/Cost', 'Meter Type']
        meter_rows = ""
        meter_heads = ""

        if checkboxes and request.form.getlist('Meter_Cost'):
            meter_rows = connect('SELECT year, month, meter_type, cost FROM MONTH_METER_COST WHERE meter_type IN ' + checkbox_string + ' AND ' + 'CAST(month AS int) BETWEEN ' + request.form['monthSel_startmonth'] + ' AND ' + request.form['monthSel_endmonth'] + ' AND CAST(year as int) = ' + request.form['monthSel_year'] + ';')
            meter_heads = ['Year', 'Month', 'Meter Type', 'Cost']
        return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meter_heads=meter_heads)
    elif (options == "MINUTE_ENERGY_SOURCE_KBTU_COST"):
        rows = connect('SELECT StartDate, StartTimestamp, cost, usage_amt, kbtupercost, meter_type FROM MINUTE_ENERGY_SOURCE_KBTU_COST WHERE StartDate = ' + '\'' + request.form['minSel_date'] + '\'' + ' AND starttimestamp BETWEEN ' + '\'' + request.form['minSel_starttime'] + '\'' + ' AND ' + '\'' + request.form['minSel_endtime'] + '\'' + ';')
        heads = ['Date', 'Time', 'Total Cost', 'Usage Amount', 'Kbtu/Cost', 'Meter Type']
        meter_rows = ""
        meter_heads = ""

        if checkboxes and request.form.getlist('Meter_Cost'):
            start_time = request.form['minSel_starttime'][:-2]
            end_time = request.form['minSel_endtime'][:-2]
            meter_rows = connect('SELECT StartDate, starttimestamp, meter_type, cost FROM MINUTE_METER_COST WHERE meter_type IN ' + checkbox_string + ' AND starttimestamp BETWEEN ' + '\'' + start_time + '\'' + ' AND ' + '\'' + end_time + '\'' + ' AND StartDate = ' + '\'' + request.form['minSel_date'] + '\'' + ';')
            meter_heads = ['Date', 'Time', 'Meter Type', 'Cost']
        return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meter_heads=meter_heads)
    else:
        return render_template('my-result.html')


# handle query POST and serve result web page
@app.route('/questiontwo_handler', methods=['POST'])
def questiontwo_handler():
    options = request.form['TimeP']
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

    if (options == "monthOption"):
        rows = connect('SELECT StartDate, Meter_Type, Usage_Amount FROM MONTH_USAGE WHERE meter_type IN ' + checkbox_string + ' AND EXTRACT(YEAR FROM StartDate) BETWEEN ' + request.form['start_year'] + ' AND ' + request.form['end_year'] + ' AND EXTRACT(MONTH FROM StartDate) = ' + request.form['q2monthSel'] + ';')
        heads = ['Date', 'Meter Type', 'Usage Amount']
        return render_template('my-result.html', rows=rows, heads=heads)
    elif (options == "seasonOption"):
        rows = connect('SELECT StartDate, Meter_Type, Usage_Amount, TypeOfSeason FROM SEASON_USAGE WHERE meter_type IN ' + checkbox_string + ' AND EXTRACT(YEAR FROM StartDate) BETWEEN ' + request.form['start_year'] + ' AND ' + request.form['end_year'] + ' AND TypeOfSeason = ' + '\'' + request.form['q2seasonSel'] + '\'' + ';')
        heads = ['Date', 'Meter Type', 'Usage Amount', 'Season']
        return render_template('my-result.html', rows=rows, heads=heads)
    else:
       return render_template('my-result.html') 

if __name__ == '__main__':
    app.run(debug = True)
