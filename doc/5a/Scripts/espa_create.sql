CREATE TABLE DATE_INTERVAL (Meter_Consumption_ID varchar(20) UNIQUE PRIMARY KEY, StartDate date, TypeOfSeason varchar(7) , StartTimestamp time);

\COPY DATE_INTERVAL(Meter_Consumption_ID, StartDate, TypeOfSeason, StartTimestamp) FROM 'DI.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE BUILDING (Portfolio_Manager_ID int UNIQUE, Name varchar(30) UNIQUE, Construction_Status varchar(50), Gross_Floor_Area int, PRIMARY KEY (Portfolio_Manager_ID, Name));

\COPY BUILDING(portfolio_manager_id, name, construction_status, gross_floor_area) FROM 'B.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE ENERGY_SOURCE (Portfolio_Manager_Meter_ID int UNIQUE, MeterName varchar(30) UNIQUE, Meter_Type varchar(30), PRIMARY KEY (Portfolio_Manager_Meter_ID, MeterName));

\COPY ENERGY_SOURCE(portfolio_manager_meter_id, metername, meter_type) FROM 'ES.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE BUILDING_TYPE (Name varchar(50) PRIMARY KEY references BUILDING(Name), Property_Type varchar(30));

\COPY BUILDING_TYPE(name, property_type) FROM 'BT.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE ENERGY_SOURCE_COST (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID) PRIMARY KEY, cost float, Usage_Amount int);

\COPY ENERGY_SOURCE_COST(portfolio_manager_meter_id, cost, usage_amount) FROM 'ESC.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE FUEL_OIL (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

\COPY FUEL_OIL(portfolio_manager_meter_id, units, metertype) FROM 'FO.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE NATURAL_GAS (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

\COPY NATURAL_GAS(portfolio_manager_meter_id, units, metertype) FROM 'NG.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE ELECTRIC_GRID (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

\COPY ELECTRIC_GRID(portfolio_manager_meter_id, units, metertype) FROM 'EG.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE OTHER_SOURCE (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

\COPY OTHER_SOURCE(portfolio_manager_meter_id, units, metertype) FROM 'OS.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE MAPS_TO (Meter_Consumption_ID varchar(20) REFERENCES DATE_INTERVAL(Meter_Consumption_ID), Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), PRIMARY KEY (Meter_Consumption_ID, Portfolio_Manager_Meter_ID));

\COPY MAPS_TO(Meter_Consumption_ID, Portfolio_Manager_Meter_ID) FROM 'MT.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE POWERED_BY (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Portfolio_Manager_ID int REFERENCES BUILDING(Portfolio_Manager_ID), PRIMARY KEY (Portfolio_Manager_ID, Portfolio_Manager_Meter_ID));

\COPY POWERED_BY(Portfolio_Manager_Meter_ID, Portfolio_Manager_ID) FROM 'PB.csv' DELIMITER ',' CSV HEADER;

