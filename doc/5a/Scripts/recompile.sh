# This file was made by the ESPA team

#this line drops the tables
psql -d ESPA_DB -f espa_drop.sql

#this line recreates the new tables
psql -d ESPA_DB -f ../DDL-Commands/DDL.sql

#this line populates the tables
psql -d ESPA_DB -f ../CSV-Files/Testing-Data/espa_load.sql

#This line can be uncommented out if desired. Otherwise, this line can be used to insert SQL queries.
psql ESPA_DB
