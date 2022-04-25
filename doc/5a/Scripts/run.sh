# This file was made by the ESPA team

#this line is to create a database named ESPA_DB
createdb ESPA_DB

#this line creates the tables
psql -d ESPA_DB -f /home/lion/Desktop/cab-project-02-1-main/doc/5a/DDL-Commands/DDL.sql

#this line populates the tables
psql -d ESPA_DB -f ../CSV-Files/Testing-Data/espa_load.sql

#The next line is currently commented out, but if you would like to work in the database to make changes or updates, this line can be uncommented out so that you will end up in the database system and all set to make changes.
psql ESPA_DB
