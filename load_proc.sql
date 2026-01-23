

CREATE OR ALTER PROCEDURE load_data AS

BEGIN
	PRINT('Truncating data from the table sales')
	TRUNCATE TABLE sales
	PRINT('Inserting data to the table sales')

	BULK INSERT sales FROM 'C:\Users\Manohar\Downloads\Walmart_Project\WalmartSalesData.csv'
	WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR ='0x0A',
				TABLOCK
		)
END
