CREATE TABLE DATE_INTERVAL (Meter_Consumption_ID varchar(20) UNIQUE PRIMARY KEY, StartDate date, TypeOfSeason varchar(7) , StartTimestamp time);

CREATE TABLE BUILDING (Portfolio_Manager_ID int UNIQUE, Name varchar(30) UNIQUE, Construction_Status varchar(50), Gross_Floor_Area int, PRIMARY KEY (Portfolio_Manager_ID, Name));

CREATE TABLE ENERGY_SOURCE (Portfolio_Manager_Meter_ID int UNIQUE, MeterName varchar(30) UNIQUE, Meter_Type varchar(30), PRIMARY KEY (Portfolio_Manager_Meter_ID, MeterName));

CREATE TABLE BUILDING_TYPE (Name varchar(50) PRIMARY KEY references BUILDING(Name), Property_Type varchar(30));

CREATE TABLE ENERGY_SOURCE_COST (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID) PRIMARY KEY, cost float, Usage_Amount int);

CREATE TABLE FUEL_OIL (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

CREATE TABLE NATURAL_GAS (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

CREATE TABLE ELECTRIC_GRID (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

CREATE TABLE OTHER_SOURCE (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Units varchar(10), MeterType varchar(30));

CREATE TABLE MAPS_TO (Meter_Consumption_ID varchar(20) REFERENCES DATE_INTERVAL(Meter_Consumption_ID), Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), PRIMARY KEY (Meter_Consumption_ID, Portfolio_Manager_Meter_ID));

CREATE TABLE POWERED_BY (Portfolio_Manager_Meter_ID int REFERENCES ENERGY_SOURCE(Portfolio_Manager_Meter_ID), Portfolio_Manager_ID int REFERENCES BUILDING(Portfolio_Manager_ID), PRIMARY KEY (Portfolio_Manager_ID, Portfolio_Manager_Meter_ID));

CREATE VIEW YEAR_ENERGY_SOURCE_KBTU_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as varchar(4)) AS Year, Cost, Usage_Amount, Usage_Amount/cast(SUM(Cost) as float) AS kbtuPerCost, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY EXTRACT(YEAR FROM StartDate), Cost, Usage_Amount, Meter_Type;

CREATE VIEW YEAR_SOURCE AS
SELECT Year, SUM(Cost) AS Cost, SUM(Usage_Amount) AS Usage_Amount,(SUM(Usage_Amount)/cast(SUM(Cost) as float)) AS kbtuPerCost
FROM YEAR_ENERGY_SOURCE_KBTU_COST
GROUP BY Year;

CREATE VIEW MONTH_ENERGY_SOURCE_KBTU_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as varchar(4)) AS Year, cast(EXTRACT(MONTH FROM StartDate) as varchar(2)) AS Month, Cost, Usage_Amount, Usage_Amount/cast(SUM(Cost) as float) AS kbtuPerCost, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY EXTRACT(YEAR FROM StartDate), EXTRACT(MONTH FROM StartDate), Cost, Usage_Amount, Meter_Type;

CREATE VIEW MONTH_SOURCE AS
SELECT Year, Month, SUM(Cost) AS Cost, SUM(Usage_Amount) AS Usage_Amount, (SUM(Usage_Amount)/cast(SUM(Cost) as float)) AS kbtuPerCost
FROM MONTH_ENERGY_SOURCE_KBTU_COST
GROUP BY Year, Month;

CREATE VIEW MINUTE_ENERGY_SOURCE_KBTU_COST AS
SELECT StartDate, StartTimestamp, cast(Cost as float)/(30 * 24 * 4) AS cost, cast(Usage_Amount as float)/ (30*24*4) AS Usage_Amt, (Usage_Amount/(cast(Cost as float)) / (30 * 24 * 4)) AS kbtuPerCost, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY StartDate, StartTimestamp, Usage_Amount, Cost, Meter_Type
ORDER BY StartDate ASC;

CREATE VIEW MINUTE_SOURCE AS
SELECT StartDate, StartTimestamp, SUM(cost) AS Cost, SUM(Usage_Amt) AS Usage_Amt, (SUM(Usage_Amt)/cast(SUM(Cost) as float)) AS kbtuPerCost
FROM MINUTE_ENERGY_SOURCE_KBTU_COST
GROUP BY StartDate, StartTimestamp;

CREATE VIEW YEAR_METER_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as varchar(4)) AS YEAR, Meter_Type, Cost
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY EXTRACT(YEAR FROM StartDate), Meter_Type, Cost;

CREATE VIEW MONTH_METER_COST AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as varchar(4)) AS YEAR, cast(EXTRACT(MONTH FROM StartDate) as varchar(2)) AS MONTH, Meter_Type, Cost
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY EXTRACT(YEAR FROM StartDate), EXTRACT(MONTH FROM StartDate), Meter_Type, Cost;

CREATE VIEW MINUTE_METER_COST AS
SELECT StartDate, StartTimestamp, Meter_Type, cast(Cost as float)/ (30*24*4) AS Cost
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY StartDate, StartTimestamp, Meter_Type, Cost
ORDER BY StartDate ASC;

CREATE VIEW MONTH_USAGE AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as varchar(4)) AS Year, cast(EXTRACT(MONTH FROM StartDate) as varchar(2)) AS Month, Meter_Type, Usage_Amount
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY EXTRACT(YEAR FROM StartDate), EXTRACT(MONTH FROM StartDate), Usage_Amount, Meter_Type;

CREATE VIEW MONTH_USAGE_SOURCE AS
SELECT Year, Month, SUM(Usage_Amount)
FROM MONTH_USAGE
GROUP BY Year, Month;

CREATE VIEW SEASON_USAGE AS
SELECT cast(EXTRACT(YEAR FROM StartDate) as varchar(4)) AS Year, cast(EXTRACT(MONTH FROM StartDate) as varchar(2)) AS Month, TypeOfSeason, Usage_Amount, Meter_Type
FROM DATE_INTERVAL NATURAL JOIN MAPS_TO NATURAL JOIN ENERGY_SOURCE_COST NATURAL JOIN ENERGY_SOURCE
GROUP BY EXTRACT(YEAR FROM StartDate), EXTRACT(MONTH FROM StartDate), TypeOfSeason, Usage_Amount, Meter_Type;

CREATE VIEW SEASON_USAGE_SOURCE AS
SELECT Year, Month, SUM(Usage_Amount), TypeOfSeason
FROM SEASON_USAGE
GROUP BY Year, Month, TypeOfSeason;
