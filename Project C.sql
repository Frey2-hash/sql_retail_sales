-- Sql Retail Sales Analysis- Project b

USE project_b;

-- Create Table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id  INT PRIMARY KEY
,sale_date	DATE
,sale_time	TIME
,customer_id INT	
,gender	VARCHAR(15)
,age	INT
,category	VARCHAR(15)
,quantiy	INT
,price_per_unit	FLOAT
,cogs	FLOAT
,total_sale FLOAT

);


-- Upload data infile to the table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SQL - Retail Sales Analysis_utf .csv'
INTO TABLE  retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY  '"'
LINES TERMINATED BY  '\n'
IGNORE 1 LINES ;
    

-- 2 EXPLORATORY DATA ANALYSIS
-- ALTER COLUMN NAME
-- RECORD COUNT
-- CUSTOMER COUNT
-- CATEGORY COUNT
-- NULL VALUE CHECK
    
ALTER TABLE retail_sales
RENAME COLUMN `quantiy` to `quantity`;
    
SELECT * FROM retail_sales;
    
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
   
   
SELECT * from retail_sales where age = 0;
SELECT * FROM retail_sales
WHERE 
age = 0 OR quantity = 0 OR price_per_unit = 0 OR cogs = 0 or total_sale = 0;
     
 DELETE FROM retail_sales
 WHERE age = 0 OR quantity = 0 OR price_per_unit = 0 OR cogs = 0 or total_sale = 0;
 
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- DATA ANALYSIS AND FINDINGS

-- 1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- 2 Write a SQL query to retrieve all transactions where the 
--   category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND 
DATE_FORMAT(sale_date,'%Y-%m') = '2022-11'
AND 
quantity >= 4 ;

-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT  DISTINCT category, SUM(total_sale) AS 'net_sales',
count(total_sale) AS 'total_order'
FROM retail_sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. round to a whole number
SELECT  round(AVG(age), 0)
FROM retail_sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale >1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender, COUNT(*)  AS 'total_trans'
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT *
FROM 
	(SELECT
	YEAR(sale_date) as 'Year',
	MONTH (sale_date) as 'Month',
	ROUND(AVG(total_sale),0)  as avg_sales,
	RANK() OVER (PARTITION BY YEAR (sale_date) ORDER BY ROUND(AVG(total_sale),0) DESC) as 'rank'
	FROM  retail_sales
	GROUP BY 1,2
    ) 
    as t1
WHERE `rank` = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT * FROM retail_sales;

SELECT customer_id, SUM(total_sale) as 'total_sales'
FROM retail_sales
GROUP BY 1 ORDER BY 2 DESC
LIMIT 5;
    
-- Write a SQL query to find the number of unique customers who purchased items from each category


SELECT * FROM retail_sales;
SELECT category, COUNT( DISTINCT customer_id) AS customer_count
FROM retail_sales
GROUP BY 1;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT * FROM retail_sales;

WITH hourly_sale
AS 
(
SELECT *,
CASE
	WHEN HOUR(sale_time) <12 THEN 'morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
    ELSE 'evening'
END as 'shift'
	FROM retail_sales
)
SELECT COUNT(transactions_id), shift
FROM hourly_sale
GROUP BY 2;






