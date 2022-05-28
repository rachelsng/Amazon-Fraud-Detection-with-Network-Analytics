-- POSTGRESQL SCRIPTS TO CREATE PRODUCT AND RATINGS TABLES

-- Create tables, import the data in from csv (right click table, import/export)
-- Import product.csv, header = no, delimiter = ;
CREATE TABLE IF NOT EXISTS product (
    item_id VARCHAR,
	title VARCHAR,
	brand VARCHAR,
	main_cat VARCHAR,
	price NUMERIC
);
---- add primary key
ALTER TABLE product
ADD PRIMARY KEY (item_id);

-- Import ratings.csv, header = no, delimiter = '
CREATE TABLE IF NOT EXISTS ratings (
    item_id VARCHAR,
	user_id VARCHAR,
	rating NUMERIC,
	date DATE
);
---- add primary key
ALTER TABLE ratings
ADD PRIMARY KEY (item_id, user_id);