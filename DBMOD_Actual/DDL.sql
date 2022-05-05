CREATE TABLE DATE_INTERVAL (Meter_Consumption_ID varchar(20) UNIQUE PRIMARY KEY, StartDate date, TypeOfSeason varchar(7) , StartTimestamp time);

CREATE TABLE BUILDING (Name varchar(50) UNIQUE, Portfolio_Manager_ID varchar(30) UNIQUE, Construction_Status varchar(50), Gross_Floor_Area int, PRIMARY KEY (Portfolio_Manager_ID, Name));

CREATE TABLE ENERGY_SOURCE (Portfolio_Manager_Meter_ID varchar(30) UNIQUE, MeterName varchar(30) UNIQUE, Meter_Type varchar(30), PRIMARY KEY (Portfolio_Manager_Meter_ID, MeterName));

CREATE TABLE BUILDING_TYPE (Name varchar(50) PRIMARY KEY references BUILDING(Name), Property_Type varchar(30));

CREATE TABLE ENERGY_SOURCE_COST (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID) PRIMARY KEY, cost float, Usage_Amount float);

CREATE TABLE FUEL_OIL (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), MeterType varchar(30), Units varchar(26));

CREATE TABLE NATURAL_GAS (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), MeterType varchar(30), Units varchar(26));

CREATE TABLE ELECTRIC_GRID (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), MeterType varchar(30), Units varchar(26));

CREATE TABLE OTHER_SOURCE (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), MeterType varchar(30), Units varchar(26));

CREATE TABLE MAPS_TO (Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Meter_Consumption_ID varchar(20) REFERENCES DATE_INTERVAL(Meter_Consumption_ID), PRIMARY KEY (Portfolio_Manager_Meter_ID, Meter_Consumption_ID));

CREATE TABLE POWERED_BY (Portfolio_Manager_ID varchar(30) REFERENCES BUILDING(Portfolio_Manager_ID), Portfolio_Manager_Meter_ID varchar(30) REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), PRIMARY KEY (Portfolio_Manager_ID, Portfolio_Manager_Meter_ID));

CREATE VIEW YEAR_ENERGY_SOURCE_KBTU_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as int) AS Year, Cost, Usage_Amount, Usage_Amount/cast(SUM(Cost) as float) AS kbtuPerCost, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY Year, Cost, Usage_Amount, Meter_Type;

CREATE VIEW YEAR_SOURCE AS
SELECT Year, SUM(Cost)::Numeric::money AS Cost, ROUND(SUM(Usage_Amount)::Numeric, 2) AS Usage_Amount, ROUND((SUM(Usage_Amount)/SUM(Cost))::Numeric, 2) AS kbtuPerCost
FROM YEAR_ENERGY_SOURCE_KBTU_COST
GROUP BY Year;

CREATE VIEW MONTH_ENERGY_SOURCE_KBTU_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as int) AS Year, cast(EXTRACT(MONTH FROM StartDate) as int) AS Month, Cost, Usage_Amount, Usage_Amount/cast(SUM(Cost) as float) AS kbtuPerCost, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY Year, Month, Cost, Usage_Amount, Meter_Type;

CREATE VIEW MONTH_SOURCE AS
SELECT Year, Month, SUM(Cost)::Numeric::money AS Cost, ROUND(SUM(Usage_Amount)::Numeric, 2) AS Usage_Amount, ROUND((SUM(Usage_Amount)/SUM(Cost))::Numeric, 2) AS kbtuPerCost
FROM MONTH_ENERGY_SOURCE_KBTU_COST
GROUP BY Year, Month;

CREATE VIEW MINUTE_ENERGY_SOURCE_KBTU_COST AS
SELECT StartDate, StartTimestamp, cast(Cost as float)/(30 * 24 * 4) AS cost, cast(Usage_Amount as float)/ (30*24*4) AS Usage_Amt, (Usage_Amount/(cast(Cost as float)) / (30 * 24 * 4)) AS kbtuPerCost, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY StartDate, StartTimestamp, Usage_Amount, Cost, Meter_Type
ORDER BY StartDate ASC;

CREATE VIEW MINUTE_SOURCE AS
SELECT StartDate, StartTimestamp, SUM(cost) AS Cost, SUM(Usage_Amt) AS Usage_Amt, SUM(Usage_Amt)/cast(SUM(Cost) as float) AS kbtuPerCost
FROM MINUTE_ENERGY_SOURCE_KBTU_COST
GROUP BY StartDate, StartTimestamp;

CREATE VIEW YEAR_METER_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as int) AS Year, Meter_Type, Cost
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY Year, Meter_Type, Cost;

CREATE VIEW YEAR_METER_COST_SOURCE AS
SELECT YEAR, Meter_Type, SUM(Cost)::Numeric::money AS Cost
FROM YEAR_METER_COST
GROUP BY YEAR, Meter_Type;

CREATE VIEW MONTH_METER_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as int) AS Year, cast(EXTRACT(MONTH FROM StartDate) as int) AS Month, Meter_Type, Cost::Numeric::money
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY Year, Month, Meter_Type, Cost;

CREATE VIEW MINUTE_METER_COST AS
SELECT StartDate, StartTimestamp, Meter_Type, (cast(Cost as float)/ (30*24*4)) AS Cost
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY StartDate, StartTimestamp, Meter_Type, Cost
ORDER BY StartDate ASC;

CREATE VIEW MONTH_USAGE AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as int) AS Year, cast(EXTRACT(MONTH FROM StartDate) as int) AS Month, Meter_Type, Usage_Amount
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY Year, Month, Usage_Amount, Meter_Type;

CREATE VIEW MONTH_USAGE_SOURCE AS
SELECT Year, Month, ROUND(SUM(Usage_Amount)::Numeric, 2) AS Usage, Meter_Type
FROM MONTH_USAGE
GROUP BY Year, Month, Meter_Type
ORDER BY Year, Month;

CREATE VIEW SEASON_USAGE AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as int) AS Year, cast(EXTRACT(MONTH FROM StartDate) as int) AS Month, TypeOfSeason, Usage_Amount, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY Year, Month, TypeOfSeason, Usage_Amount, Meter_Type;

CREATE VIEW SEASON_USAGE_SOURCE AS
SELECT Year, ROUND(SUM(Usage_Amount)::Numeric, 2) AS Usage, TypeOfSeason, Meter_Type
FROM SEASON_USAGE
GROUP BY Year, TypeOfSeason, Meter_Type
ORDER BY Year;
