\COPY DATE_INTERVAL(Meter_Consumption_ID, StartDate, TypeOfSeason, StartTimestamp) FROM '../CSV-Files/Testing-Data/DI.csv' DELIMITER ',' CSV HEADER;

\COPY BUILDING(portfolio_manager_id, name, construction_status, gross_floor_area) FROM '../CSV-Files/Testing-Data/B.csv' DELIMITER ',' CSV HEADER;

\COPY ENERGY_SOURCE(portfolio_manager_meter_id, metername, meter_type) FROM '../CSV-Files/Testing-Data/ES.csv' DELIMITER ',' CSV HEADER;

\COPY BUILDING_TYPE(name, property_type) FROM '../CSV-Files/Testing-Data/BT.csv' DELIMITER ',' CSV HEADER;

\COPY ENERGY_SOURCE_COST(portfolio_manager_meter_id, cost, usage_amount) FROM '../CSV-Files/Testing-Data/ESC.csv' DELIMITER ',' CSV HEADER;

\COPY FUEL_OIL(portfolio_manager_meter_id, units, metertype) FROM '../CSV-Files/Testing-Data/FO.csv' DELIMITER ',' CSV HEADER;

\COPY NATURAL_GAS(portfolio_manager_meter_id, units, metertype) FROM '../CSV-Files/Testing-Data/NG.csv' DELIMITER ',' CSV HEADER;

\COPY ELECTRIC_GRID(portfolio_manager_meter_id, units, metertype) FROM '../CSV-Files/Testing-Data/EG.csv' DELIMITER ',' CSV HEADER;

\COPY OTHER_SOURCE(portfolio_manager_meter_id, units, metertype) FROM '../CSV-Files/Testing-Data/OS.csv' DELIMITER ',' CSV HEADER;

\COPY MAPS_TO(Meter_Consumption_ID, Portfolio_Manager_Meter_ID) FROM '../CSV-Files/Testing-Data/MT.csv' DELIMITER ',' CSV HEADER;

\COPY POWERED_BY(Portfolio_Manager_Meter_ID, Portfolio_Manager_ID) FROM '../CSV-Files/Testing-Data/PB.csv' DELIMITER ',' CSV HEADER;

