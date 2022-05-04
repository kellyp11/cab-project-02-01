\COPY DATE_INTERVAL(Meter_Consumption_ID, StartDate, TypeOfSeason, StartTimestamp) FROM '../DBMOD_Actual/DI.csv' DELIMITER ',' CSV HEADER;

\COPY BUILDING(name, portfolio_manager_id, construction_status, gross_floor_area) FROM '../DBMOD_Actual/B.csv' DELIMITER ',' CSV HEADER;

\COPY ENERGY_SOURCE(portfolio_manager_meter_id, metername, meter_type) FROM '../DBMOD_Actual/ES.csv' DELIMITER ',' CSV HEADER;

\COPY BUILDING_TYPE(name, property_type) FROM '../DBMOD_Actual/BT.csv' DELIMITER ',' CSV HEADER;

\COPY ENERGY_SOURCE_COST(portfolio_manager_meter_id, cost, usage_amount) FROM '../DBMOD_Actual/ESC.csv' DELIMITER ',' CSV HEADER;

\COPY FUEL_OIL(portfolio_manager_meter_id, metertype, units) FROM '../DBMOD_Actual/FO.csv' DELIMITER ',' CSV HEADER;

\COPY NATURAL_GAS(portfolio_manager_meter_id, metertype, units) FROM '../DBMOD_Actual/NG.csv' DELIMITER ',' CSV HEADER;

\COPY ELECTRIC_GRID(portfolio_manager_meter_id, metertype, units) FROM '../DBMOD_Actual/EG.csv' DELIMITER ',' CSV HEADER;

\COPY OTHER_SOURCE(portfolio_manager_meter_id, metertype, units) FROM '../DBMOD_Actual/OS.csv' DELIMITER ',' CSV HEADER;

\COPY MAPS_TO(Portfolio_Manager_Meter_ID, Meter_Consumption_ID) FROM '../DBMOD_Actual/MT.csv' DELIMITER ',' CSV HEADER;

\COPY POWERED_BY(Portfolio_Manager_ID, Portfolio_Manager_Meter_ID) FROM '../DBMOD_Actual/PB.csv' DELIMITER ',' CSV HEADER;

