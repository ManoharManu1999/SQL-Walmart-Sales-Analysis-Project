-- Switch to master before dropping DB
USE master

-- Switch to master before dropping DB
DROP DATABASE IF EXISTS Walmart

-- Drop database if exists
CREATE Database Walmart

-- Use Walmart database
USE Walmart

-- Drop table if exists
DROP TABLE IF EXISTS sales

-- Create table
CREATE TABLE sales(
		invoice_id				VARCHAR(50) NOT NULL,
		branch					VARCHAR(30) NOT NULL,
		city					VARCHAR(30) NOT NULL,
		customer_type			VARCHAR(30) NOT NULL,
		gender					VARCHAR(30) NOT NULL,
		product_line			VARCHAR(30) NOT NULL,
		unit_price				DECIMAL(10,2) NOT NULL,
		quantity				INT NOT NULL,
		tax						DECIMAL(10,2) NOT NULL,
		total					DECIMAL(10,2) NOT NULL,
		ordered_date			DATETIME NOT NULL,
		ordered_time			TIME NOT NULL,
		payment_method			VARCHAR(30) NOT NULL,
		cogs					DECIMAL(10,2) NOT NULL,
		gross_margin_percentage	DECIMAL(10,2) NOT NULL,
		gross_income			DECIMAL(10,2) NOT NULL,
		rating					FLOAT NOT NULL,
		CONSTRAINT pk_sales PRIMARY KEY(invoice_id)
)

