\COPY DATE_INTERVAL(Meter_Consumption_ID, StartDate, TypeOfSeason, StartTimestamp) FROM 'DI.csv' DELIMITER ',' CSV HEADER;

\COPY BUILDING(portfolio_manager_id, name, construction_status, gross_floor_area) FROM 'B.csv' DELIMITER ',' CSV HEADER;

\COPY ENERGY_SOURCE(portfolio_manager_meter_id, metername, meter_type) FROM 'ES.csv' DELIMITER ',' CSV HEADER;

\COPY BUILDING_TYPE(name, property_type) FROM 'BT.csv' DELIMITER ',' CSV HEADER;

\COPY ENERGY_SOURCE_COST(portfolio_manager_meter_id, cost, usage_amount) FROM 'ESC.csv' DELIMITER ',' CSV HEADER;

\COPY FUEL_OIL(portfolio_manager_meter_id, units, metertype) FROM 'FO.csv' DELIMITER ',' CSV HEADER;

\COPY NATURAL_GAS(portfolio_manager_meter_id, units, metertype) FROM 'NG.csv' DELIMITER ',' CSV HEADER;

\COPY ELECTRIC_GRID(portfolio_manager_meter_id, units, metertype) FROM 'EG.csv' DELIMITER ',' CSV HEADER;

\COPY OTHER_SOURCE(portfolio_manager_meter_id, units, metertype) FROM 'OS.csv' DELIMITER ',' CSV HEADER;

\COPY MAPS_TO(Meter_Consumption_ID, Portfolio_Manager_Meter_ID) FROM 'MT.csv' DELIMITER ',' CSV HEADER;

\COPY POWERED_BY(Portfolio_Manager_Meter_ID, Portfolio_Manager_ID) FROM 'PB.csv' DELIMITER ',' CSV HEADER;

