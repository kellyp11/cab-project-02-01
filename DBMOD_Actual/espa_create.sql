CREATE TABLE DATE_INTERVAL (Meter_Consumption_ID varchar(20) UNIQUE PRIMARY KEY, StartDate date, TypeOfSeason varchar(7) , StartTimestamp time);

CREATE TABLE BUILDING (Name varchar(50) UNIQUE, Portfolio_Manager_ID varchar(30) UNIQUE, Construction_Status varchar(50), Gross_Floor_Area int, PRIMARY KEY (Portfolio_Manager_ID, Name));

CREATE TABLE ENERGY_SOURCE (Portfolio_Manager_Meter_ID varchar(30) UNIQUE, MeterName varchar(30) UNIQUE, Meter_Type varchar(30), PRIMARY KEY (Portfolio_Manager_Meter_ID, MeterName));

CREATE TABLE BUILDING_TYPE (Name varchar(50) PRIMARY KEY references BUILDING(Name), Property_Type varchar(30));

CREATE TABLE ENERGY_SOURCE_COST (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID) PRIMARY KEY, cost float, Usage_Amount float);

CREATE TABLE FUEL_OIL (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(25), MeterType varchar(30));

CREATE TABLE NATURAL_GAS (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(25), MeterType varchar(30));

CREATE TABLE ELECTRIC_GRID (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(25), MeterType varchar(30));

CREATE TABLE OTHER_SOURCE (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(25), MeterType varchar(30));

CREATE TABLE MAPS_TO (Meter_Consumption_ID varchar(20) REFERENCES DATE_INTERVAL(Meter_Consumption_ID), Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), PRIMARY KEY (Meter_Consumption_ID, Portfolio_Manager_Meter_ID));

CREATE TABLE POWERED_BY (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Portfolio_Manager_ID varchar(30) REFERENCES BUILDING(Portfolio_Manager_ID), PRIMARY KEY (Portfolio_Manager_ID, Portfolio_Manager_Meter_ID));
