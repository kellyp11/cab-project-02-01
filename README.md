<h1 style="align: center"> ESPA - Energy Supply Project Analysis ⚡🔋 </h1> 

## Table of Contents

- [Introduction](#introduction)
- [Goal](#goal)
- [Usage](#usage)
- [Build Process](#build-process)
- [Contributors](#contributors)
- [Acknowledgements](#acknowledgements)

## Introduction
Welcome to our web application! This is a web application that will be developed with Flask and PostgreSQL.

## Goal
The user will be able to witness trends in data between the Natural Gas/Fuel Oil from our power plant and the power coming from our Electric grid. The user will be able to see the usage of such energy sources on a season by season basis to observe the fluctuations that may occur throughout the years. The user will also have access to a energy-efficiency analysis computed within the application.

## Usage
  
All of the necessary files needed to run the application are within DBMOD_ACTUAL.\
Once you navigate to that directory, you just need to run:
```
sh run.sh
```

From there, you navigate to the source folder to run the actual web application.\
This is how to run the application:
```
export FLASK_APP=app.py
flask run
# then browse to http://127.0.0.1:5000/
```

## Build Process
We spent the majority of the project working on the database. Until Stage 5b, we were working purely with the database. From there, we implemented the flask files in the src folder, which are used to run the web application that queries the database. Here's a more specific breakdown:

- Stage I: Formed project groups
- Stage II: Brainstormed ideas and developed project proposal
- Stage III: Revised project proposal, create ER diagram and a relational schema (mapped ER diagram to the schema)
- Mid-Semester Project Presentation: Demonstrate to client the design and queries that will be used
- Stage IV: Designed all of the tables, views, and SQL queries that will be used in PostgreSQL by the application
- Stage Va: Write and execute all of the SQL commands that will create the tables to verify the commands work, Write scripts to obtain and format the data, and populate tables with valid Data
- Stage Vb: Create user interface to execute queries
- Stage VI: Create slies to present summary of project and working of module
- Stage VII: Create final report and handed over project to client


[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=6878204&assignment_repo_type=AssignmentRepo)

## Contributors

* [Grant Bushoven](https://github.com/grantbushoven)
* [Sterly Deracy](https://github.com/sderacy)
* [Peter Kelly](https://github.com/kellyp11)
* [Daniel Melamed](https://github.com/dmelamed5)
* [Joseph Oczkowski](https://github.com/Joe-Oczkowski)
* [Matthew Seitz](https://github.com/matt2970)
* [Amy Vargas](https://github.com/A-Vargas-GP)


## Acknowledgements

* Bih-Horng Chiang
* John Degood
* Paul Romano
