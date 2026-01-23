-- **********************************************************
-- *******			Feature Engineering:	      ***********
-- **********************************************************

/* 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. 
   This will help answer the question on which part of the day most sales are made */


SELECT 
	invoice_id,
	branch,
	city,
	customer_type,
	gender,
	product_line,
	unit_price,
	quantity,
	tax,
	total,
	order_date,
	order_time,
	CASE
		WHEN DATEPART(HOUR,order_time) >=10 AND DATEPART(HOUR,order_time) <= 12 THEN 'Morning'
		WHEN DATEPART(HOUR,order_time) >12 AND  DATEPART(HOUR,order_time) <=16 THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day,
	payment_method,
	cogs,
	gross_margin_percentage,
	gross_income,
	rating
FROM sales

/* 2. Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
This will help answer the question on which week of the day each branch is busiest.*/

SELECT 
	order_date,
	DATENAME(WEEKDAY, order_date) AS day_name
FROM sales

/* 3. Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 
Help determine which month of the year has the most sales and profit.*/

SELECT 
	order_date,
	DATENAME(MONTH, order_date) AS day_name
FROM sales

-- **********************************************************
-- *******			Generic Questions:   	      ***********
-- **********************************************************


/* ============================================================
   BUSINESS QUESTION 1 & 2:
   How many unique cities are present in the dataset and 
   which branch operates in each city?

   INSIGHT:
   - The dataset contains 3 cities: Yangon, Mandalay, Naypyitaw
   - Each city has exactly one branch assigned
   - This allows clean city-level and branch-level analysis

   BUSINESS VALUE:
   - Enables geographical performance comparison
   - Supports location-based business insights
   - Simplifies branch-wise reporting
============================================================ */


/* 1. How many unique cities does the data have? */

SELECT 
	DISTINCT(city) AS cities
FROM sales

/* 2. In which city is each branch? */

SELECT 
	city,
	branch
FROM sales
GROUP BY city,branch

-- **********************************************************
-- *******			Product Questions:   	      ***********
-- **********************************************************

/* ============================================================
   BUSINESS QUESTION 1:
   How many unique product lines exist in the dataset?

   INSIGHT:
   - The dataset contains 6 distinct product categories
   - Categories span essentials and lifestyle products
   - Enables category-wise revenue and performance analysis
============================================================ */

SELECT 
	DISTINCT(product_line) AS product_categories
FROM sales

/* ======================================================
BUSINESS QUESTION 2:
What is the most common payment method?

   INSIGHT:
   - E-wallet is the most frequently used payment method
   - Indicates higher digital payment adoption
   - Useful for planning offers & POS optimization

   BUSINESS VALUE:
   - Helps identify high- and low-performing product lines
   - Supports inventory and marketing strategy decisions
====================================================== */

SELECT 
	payment_method, 
	COUNT(payment_method) AS total_payment_method
FROM sales
GROUP BY payment_method
ORDER BY COUNT(payment_method) DESC

/* ============================================================
   BUSINESS QUESTION 3:
   What is the most selling product line based on total revenue?

   INSIGHT:
   - Food and Beverages generates the highest total sales
   - Other categories show closely competing performance
   - Health and Beauty records the lowest sales

   BUSINESS VALUE:
   - Helps prioritize high-revenue categories
   - Supports inventory planning and promotions
   - Identifies underperforming product lines
============================================================ */

SELECT 
	product_line,
	SUM(total) AS total_sales
FROM sales
GROUP BY product_line
ORDER BY SUM(total) DESC

/* ============================================================
   BUSINESS QUESTION 4 :
   What is the total revenue generated each month?

   INSIGHT:
   - January records the highest total revenue
   - February shows a decline in sales
   - March recovers with increased revenue

   BUSINESS VALUE:
   - Helps identify seasonal sales trends
   - Supports monthly performance tracking
   - Useful for forecasting and budgeting
============================================================ */

SELECT 
	DATENAME(MONTH, order_date) AS months_name,
	SUM(total) AS total_sales
FROM sales
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date)

/* ============================================================
   BUSINESS QUESTION 5:
   Which month recorded the highest Cost of Goods Sold (COGS)?

   INSIGHT:
   - January has the highest COGS, indicating higher sales volume
   - February records the lowest cost
   - March shows recovery in operational activity

   BUSINESS VALUE:
   - Helps analyze profitability trends
   - Supports inventory and cost management decisions
   - Useful for monthly financial planning
============================================================ */

SELECT 
	DATENAME(MONTH, order_date) AS months_name,
	SUM(cogs) AS total_cogs
FROM sales
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)

/* ============================================================
   BUSINESS QUESTION 6:
   Which city generates the highest total revenue?

   INSIGHT:
   - Naypyitaw has the highest revenue among all cities
   - Yangon and Mandalay show comparable performance
   - Indicates strong market potential in Naypyitaw

   BUSINESS VALUE:
   - Supports location-based business decisions
   - Helps prioritize high-performing branches
   - Useful for regional sales strategy
============================================================ */

SELECT 
	city,
	SUM(total) AS revenue
FROM sales
GROUP BY city
ORDER BY SUM(total) DESC

/* ============================================================
   BUSINESS QUESTION 7:
   Which product line generates the highest VAT?

   INSIGHT:
   - Food and Beverages contributes the highest VAT
   - Sports and Travel and Electronic Accessories follow closely
   - Health and Beauty contributes the least VAT

   BUSINESS VALUE:
   - Helps identify high-revenue product categories
   - Useful for tax reporting and financial planning
   - Supports category-level performance analysis
============================================================ */

SELECT
	product_line,
	SUM(tax) AS total_vat	
FROM sales 
GROUP BY product_line
ORDER By SUM(tax) DESC

/* ============================================================
   BUSINESS QUESTION 8:
   Which product lines perform above or below the overall 
   average sales?

   INSIGHT:
   - Home & Lifestyle, Health & Beauty, and Sports & Travel
     perform above the overall average
   - Fashion Accessories, Electronic Accessories, and
     Food & Beverages perform below average

   BUSINESS VALUE:
   - Helps classify product lines into high and low performers
   - Supports inventory and promotion strategy
   - Enables data-driven category optimization
============================================================ */

WITH cte_total_by_product_ine AS
(
	SELECT 
		product_line,
		ROUND(AVG(total),2) AS avg_total_by_product_line
	FROM sales
	GROUP BY product_line
),
cte_avg_sales AS
(
	SELECT 
		ROUND(AVG(total),2) AS avg_total
	FROM sales
)
SELECT
p.product_line,
p.avg_total_by_product_line,
a.avg_total,
CASE
	WHEN p.avg_total_by_product_line > a.avg_total THEN 'Good'
	ELSE 'Bad'
END AS status
FROM cte_total_by_product_ine AS p
CROSS JOIN cte_avg_sales AS a

/* ============================================================
   BUSINESS QUESTION 9:
   Which branches sold more products than the average quantity?

   INSIGHT:
   - All branches (A, B, C) perform above the average quantity sold
   - Branch A records the highest total quantity sold
   - Sales distribution across branches is consistent

   BUSINESS VALUE:
   - Indicates balanced branch performance
   - Helps identify high-performing locations
   - Supports operational and inventory planning
============================================================ */


;WITH cte_avg_branch AS(
SELECT 
	branch,
	SUM(quantity) AS total_quantity,
	AVG(quantity) AS avg_quantity
FROM sales
GROUP BY branch)

SELECT *,
	CASE
		WHEN total_quantity > avg_quantity THEN 'Above Average'
		ELSE 'Below Average'
	END AS performance
FROM cte_avg_branch

/* ============================================================
   BUSINESS QUESTION 10:
   What is the most common product line purchased by each gender?

   INSIGHT:
   - Female customers most frequently purchase Fashion Accessories
   - Male customers most frequently purchase Health and Beauty products

   BUSINESS VALUE:
   - Enables gender-based marketing strategies
   - Helps optimize product placement and promotions
   - Supports customer segmentation analysis
============================================================ */


;WITH cte_total_quantity AS 
(SELECT 
	gender,
	product_line,	
	SUM(quantity) AS total_quantity,
	RANK() OVER(PARTITION BY gender ORDER BY SUM(quantity) DESC) AS ranking
FROM sales
GROUP BY product_line, gender)
SELECT 
	gender,
	product_line,
	total_quantity
FROM cte_total_quantity
WHERE ranking = 1

/* ============================================================
   BUSINESS QUESTION 11:
   What is the average customer rating for each product line?

   INSIGHT:
   - Food and Beverages has the highest average rating
   - Fashion Accessories and Health & Beauty perform well
   - Home & Lifestyle receives the lowest ratings

   BUSINESS VALUE:
   - Helps measure customer satisfaction by category
   - Supports product quality and service improvements
   - Guides customer experience optimization
============================================================ */

SELECT 
	product_line,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY AVG(rating) DESC


-- **********************************************************
-- *********			Sales Questions:   	      ***********
-- **********************************************************


/* ============================================================
   BUSINESS QUESTION 1:
   How do sales vary by time of day across weekdays?

   INSIGHT:
   - Evening time consistently records the highest number of sales
   - Saturday evening has the highest sales volume
   - Morning sales are lowest across all weekdays
   - Weekends perform better than weekdays

   BUSINESS VALUE:
   - Helps optimize store staffing and working hours
   - Supports time-based promotional strategies
   - Useful for demand forecasting and operations planning
============================================================ */


WITH SalesByTime AS (
    SELECT
        DATENAME(WEEKDAY, order_date) AS week_day,
        DATEPART(WEEKDAY, order_date) AS week_day_no,
        CASE
            WHEN DATEPART(HOUR, order_time) BETWEEN 10 AND 12 THEN 'Morning'
            WHEN DATEPART(HOUR, order_time) BETWEEN 13 AND 16 THEN 'Afternoon'
            ELSE 'Evening'
        END AS time_of_day
    FROM sales
)
SELECT
    week_day,
    time_of_day,
    COUNT(*) AS total_sales
FROM SalesByTime
GROUP BY week_day, week_day_no, time_of_day
ORDER BY week_day_no, total_sales DESC;

/* ============================================================
   BUSINESS QUESTION 2:
   Which customer type generates the highest revenue?

   INSIGHT:
   - Member customers contribute more revenue than normal customers
   - Indicates higher loyalty and purchase frequency among members

   BUSINESS VALUE:
   - Supports investment in loyalty programs
   - Helps improve customer retention strategies
   - Useful for customer segmentation and targeting
============================================================ */


SELECT 
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY SUM(total) DESC


/* ============================================================
   BUSINESS QUESTION 3:
   Which customer type contributes the highest VAT?

   INSIGHT:
   - Member customers pay more VAT than normal customers
   - Indicates higher transaction value and purchase volume

   BUSINESS VALUE:
   - Supports loyalty and retention strategies
   - Helps analyze customer profitability
   - Useful for financial and tax planning
============================================================ */


SELECT
	customer_type,
	SUM(tax) AS total_tax
FROM sales
GROUP BY customer_type


-- **********************************************************
-- *********		Customer Questions:      	  ***********
-- **********************************************************

/* ============================================================
   BUSINESS QUESTION 1:
   How many unique customer types exist in the dataset?

   INSIGHT:
   - There are two customer types: Member and Normal
   - Indicates a membership-based customer model

   BUSINESS VALUE:
   - Enables customer segmentation analysis
   - Helps evaluate loyalty and retention strategies
============================================================ */

SELECT 
	DISTINCT(customer_type) AS customer_types
FROM sales

/* ============================================================
   BUSINESS QUESTION 2:
   How many unique payment methods are available?

   INSIGHT:
   - The dataset contains three payment methods:
     Credit Card, Cash, and E-wallet
   - Indicates support for both digital and traditional payments

   BUSINESS VALUE:
   - Helps analyze customer payment preferences
   - Useful for payment system optimization
   - Supports digital adoption analysis
============================================================ */

SELECT 
	DISTINCT(payment_method) AS payment_modes
FROM sales

/* ============================================================
   BUSINESS QUESTION 3:
   What is the most common customer type?

   INSIGHT:
   - Member customers slightly outnumber Normal customers
   - Customer base is evenly distributed between both types

   BUSINESS VALUE:
   - Helps evaluate membership adoption
   - Supports loyalty and retention strategies
   - Useful for customer segmentation analysis
============================================================ */


SELECT 
	customer_type,
	COUNT(*) AS total_customers
FROM sales
GROUP BY customer_type

/* ============================================================
   BUSINESS QUESTION 4:
   Which customer type generates the most sales?

   INSIGHT:
   - Member customers generate higher total sales
   - Indicates stronger purchasing behavior and loyalty

   BUSINESS VALUE:
   - Supports membership and loyalty programs
   - Helps improve customer retention strategies
   - Useful for revenue-focused segmentation
============================================================ */

SELECT 
	customer_type,
	SUM(total) AS total_sales
FROM sales
GROUP BY customer_type

/* ============================================================
   BUSINESS QUESTION 5:
   What is the gender distribution of customers?

   INSIGHT:
   - Female customers slightly outnumber male customers
   - Overall customer base is evenly distributed by gender

   BUSINESS VALUE:
   - Supports balanced marketing strategies
   - Helps in customer segmentation and targeting
   - Indicates wide demographic appeal
============================================================ */

SELECT 
	gender,
	COUNT(*) AS customer_count
FROM sales
GROUP BY gender

/* ============================================================
   BUSINESS QUESTION 6:
   What is the gender distribution across branches?

   INSIGHT:
   - Branch A and B have slightly more male customers
   - Branch C has a higher proportion of female customers
   - Overall gender distribution is well balanced

   BUSINESS VALUE:
   - Helps design branch-specific marketing strategies
   - Supports targeted promotions based on demographics
   - Provides insight into regional customer behavior
============================================================ */

SELECT 
	t.*,
	SUM(total_gender_count) OVER(PARTITION BY branch) AS total_gender_count_by_branch,
	CONCAT(
		ROUND(
			CAST(t.total_gender_count AS FLOAT)/ SUM(total_gender_count) OVER(PARTITION BY branch)*100,
			2),
			' ', '%') AS gender_distribution
FROM
	(SELECT	
		branch,
		gender,
		COUNT(gender) AS total_gender_count
	FROM sales
	GROUP BY branch,gender)t

/* ============================================================
   BUSINESS QUESTION 7: 
   At what time of day do customers give the highest ratings?

   INSIGHT:
   - Morning hours receive the highest average ratings
   - Afternoon and evening ratings are slightly lower
   - Indicates better service quality or customer experience in mornings

   BUSINESS VALUE:
   - Helps optimize staff scheduling
   - Supports service quality improvement initiatives
   - Identifies best-performing service time slots
============================================================ */

WITH cte_rating AS 
(
SELECT 
	rating,
	CASE
		WHEN DATEPART(HOUR,order_time) >=10 AND DATEPART(HOUR,order_time) <= 12 THEN 'Morning'
		WHEN DATEPART(HOUR,order_time) >12 AND  DATEPART(HOUR,order_time) <=16 THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day
FROM sales
)
SELECT 
	time_of_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM cte_rating
GROUP BY time_of_day
ORDER BY AVG(rating) DESC

/* ============================================================
   BUSINESS QUESTION 8:
   At what time of day do customers give the highest ratings 
   across different branches?

   INSIGHT:
   - Branch A performs best during Afternoon
   - Branch B performs best during Morning
   - Branch C performs best during Morning and Evening
   - Afternoon ratings are generally lower across branches

   BUSINESS VALUE:
   - Helps optimize staffing schedules
   - Identifies peak service performance windows
   - Supports branch-level service improvement strategies
============================================================ */

WITH cte_rating AS 
(
SELECT 
	branch,
	rating,
	CASE
		WHEN DATEPART(HOUR,order_time) >=10 AND DATEPART(HOUR,order_time) <= 12 THEN 'Morning'
		WHEN DATEPART(HOUR,order_time) >12 AND  DATEPART(HOUR,order_time) <=16 THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day
FROM sales
)
SELECT 
	branch,
	time_of_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM cte_rating
GROUP BY branch, time_of_day
ORDER BY branch ASC, AVG(rating) DESC

/* ============================================================
   BUSINESS QUESTION 9:
   Which day of the week has the highest average customer rating?

   INSIGHT:
   - Monday has the highest average rating
   - Wednesday records the lowest customer ratings
   - Customer satisfaction varies significantly by day

   BUSINESS VALUE:
   - Helps optimize staffing and scheduling
   - Identifies days requiring service improvement
   - Supports customer experience optimization
============================================================ */

SELECT 
	DATENAME(WEEKDAY, order_date) AS Week_day,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY AVG(rating) DESC

/* ============================================================
   BUSINESS QUESTION 10:
   Which day of the week has the highest average rating per branch?

   INSIGHT:
   - Branch A performs best on Friday
   - Branch B performs best on Monday
   - Branch C performs best on Friday

   BUSINESS VALUE:
   - Helps identify peak service days per branch
   - Supports branch-level scheduling and promotions
   - Improves customer experience planning
============================================================ */

SELECT t.branch,
		t.Week_day,
		t.avg_rating
FROM

(SELECT
	branch,
	DATENAME(WEEKDAY, order_date) AS Week_day,
	ROUND(AVG(rating),2) AS avg_rating,
	RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS ranking
FROM sales
GROUP BY branch, DATENAME(WEEKDAY, order_date))t
WHERE ranking =1