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

# Serves webpage for first question queries
@app.route("/question1")
def question1():
    return render_template('question-1.html')

# Serves webpage for second question queries
@app.route("/question2")
def question2():
    return render_template('question-2.html')

# Handle question 1 queries and serve result page
@app.route('/questionone_handler', methods=['POST'])
def questioneone_handler():
    # Retrieves radio button selection 
    options = request.form['ENERGY_SOURCE_KBTU_COST']
    
    # Retrieves list of checkboxes checked
    # This list will be used for a IN sql fetch later,
    # and the format is (x,y,z). We will assemble this string.
    checkboxes = request.form.getlist('Meter_Type')
    size = len(checkboxes)
    index = 0
    checkbox_string = "("
    
    # We will add to the string as many checkboxes are selected"
    for checkbox in checkboxes:
        index += 1
        if index == size:
            checkbox_string = checkbox_string + '\'' + checkbox + '\''
        else:
            checkbox_string = checkbox_string + '\'' + checkbox + '\'' + ',' 
    checkbox_string += ")"

    # If they select the yearly option, run the year sql queries.
    if (options == "YEAR_ENERGY_SOURCE_KBTU_COST"):
        rows = connect('SELECT year, cost, usage_amount, kbtupercost FROM YEAR_SOURCE WHERE CAST(year AS int) BETWEEN ' + request.form['yearSel_startyear'] + ' AND ' + request.form['yearSel_endyear'] + ' ORDER BY year;')
        heads = ['Year', 'Total Cost', 'Usage Amount (kbtu)', 'Kbtu/Cost']
        meter_rows = ""
        meter_heads = ""

        # If they select show meter costs, show that too
        if checkboxes and request.form.getlist('Meter_Cost'):
            meter_rows = connect('SELECT year, meter_type, cost FROM YEAR_METER_COST_SOURCE WHERE meter_type IN ' + checkbox_string + ' AND ' + 'CAST(year AS int) BETWEEN ' + request.form['yearSel_startyear'] + ' AND ' + request.form['yearSel_endyear'] + ' ORDER BY year;')
            meter_heads = ['Year', 'Meter Type', 'Cost']
        return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meter_heads=meter_heads)

    # If they select the monthly option, run the year sql queries.    
    elif (options == "MONTH_ENERGY_SOURCE_KBTU_COST"):
        rows = connect('SELECT year, month, cost, usage_amount, kbtupercost FROM MONTH_SOURCE WHERE CAST(year AS int) = ' + request.form['monthSel_year'] + ' AND CAST(month AS int) BETWEEN ' + request.form['monthSel_startmonth'] + ' AND ' + request.form['monthSel_endmonth'] + ' ORDER BY year, month ASC;')
        heads = ['Year', 'Month', 'Total Cost', 'Usage Amount (kbtu)', 'Kbtu/Cost']
        meter_rows = ""
        meter_heads = ""

        # If they select show meter costs, show that too
        if checkboxes and request.form.getlist('Meter_Cost'):
            meter_rows = connect('SELECT year, month, meter_type, cost FROM MONTH_METER_COST WHERE meter_type IN ' + checkbox_string + ' AND ' + 'CAST(month AS int) BETWEEN ' + request.form['monthSel_startmonth'] + ' AND ' + request.form['monthSel_endmonth'] + ' AND CAST(year as int) = ' + request.form['monthSel_year'] + 'ORDER BY year, month ASC;')
            meter_heads = ['Year', 'Month', 'Meter Type', 'Cost']
        return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meter_heads=meter_heads)

    # If they select the minute option, run the year sql queries.    
    elif (options == "MINUTE_ENERGY_SOURCE_KBTU_COST"):
        rows = connect('SELECT StartDate, StartTimestamp, cost, usage_amt, kbtupercost FROM MINUTE_SOURCE WHERE StartDate = ' + '\'' + request.form['minSel_date'] + '\'' + ' AND starttimestamp BETWEEN ' + '\'' + request.form['minSel_starttime'] + '\'' + ' AND ' + '\'' + request.form['minSel_endtime'] + '\'' + ' ORDER BY StartTimestamp;')
        heads = ['Date', 'Time', 'Total Cost', 'Usage Amount (kbtu)', 'Kbtu/Cost']
        meter_rows = ""
        meter_heads = ""

        # If they select show meter costs, show that too
        if checkboxes and request.form.getlist('Meter_Cost'):
            start_time = request.form['minSel_starttime'][:-2]
            end_time = request.form['minSel_endtime'][:-2]
            meter_rows = connect('SELECT StartDate, starttimestamp, meter_type, cost FROM MINUTE_METER_COST WHERE meter_type IN ' + checkbox_string + ' AND starttimestamp BETWEEN ' + '\'' + start_time + '\'' + ' AND ' + '\'' + end_time + '\'' + ' AND StartDate = ' + '\'' + request.form['minSel_date'] + '\'' + ' ORDER BY StartTimestamp;')
            meter_heads = ['Date', 'Time', 'Meter Type', 'Cost']
        return render_template('my-result.html', rows=rows, heads=heads, meter_rows=meter_rows, meter_heads=meter_heads)

    # Otherwise, return a blank page    
    else:
        return render_template('my-result.html')


# Handle question 2 queries and serve result page
@app.route('/questiontwo_handler', methods=['POST'])
def questiontwo_handler():
    # Retrieves radio button selection 
    options = request.form['TimeP']

    # Retrieves list of checkboxes checked
    # This list will be used for a IN sql fetch later,
    # and the format is (x,y,z). We will assemble this string.
    checkboxes = request.form.getlist('Meter_Type')
    size = len(checkboxes)
    index = 0
    checkbox_string = "("

    # We will add to the string as many checkboxes are selected"
    for checkbox in checkboxes:
        index += 1
        if index == size:
            checkbox_string = checkbox_string + '\'' + checkbox + '\''
        else:
            checkbox_string = checkbox_string + '\'' + checkbox + '\'' + ',' 
    checkbox_string += ")"

    # If they select the month usage option, run the month usage sql queries.
    if (options == "monthOption"):
        rows = connect('SELECT Year, Month, Meter_Type, Usage FROM MONTH_USAGE_SOURCE WHERE meter_type IN ' + checkbox_string + ' AND Cast(Year AS int) BETWEEN ' + request.form['start_year'] + ' AND ' + request.form['end_year'] + ' AND Cast(Month AS int) = ' + request.form['q2monthSel'] + ';')
        heads = ['Year', 'Month', 'Meter Type', 'Usage Amount (kbtu)']
        return render_template('my-result.html', rows=rows, heads=heads)

    # If they select the season usage option, run the season usage sql queries
    elif (options == "seasonOption"):
        rows = connect('SELECT Year, Meter_Type, Usage, TypeOfSeason FROM SEASON_USAGE_SOURCE WHERE meter_type IN ' + checkbox_string + ' AND Cast(Year AS int) BETWEEN ' + request.form['start_year'] + ' AND ' + request.form['end_year'] + ' AND TypeOfSeason = ' + '\'' + request.form['q2seasonSel'] + '\'' + ';')
        heads = ['Date', 'Meter Type', 'Usage Amount (kbtu)', 'Season']
        return render_template('my-result.html', rows=rows, heads=heads)

    # Otherwise, return an empty page
    else:
       return render_template('my-result.html') 

if __name__ == '__main__':
    app.run(debug = True)
