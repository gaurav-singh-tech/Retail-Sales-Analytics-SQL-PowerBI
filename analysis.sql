-- ---------------------------------------------------------
-- DATA ANALYSIS PROJECT: RETAIL SALES
-- ---------------------------------------------------------

-- 1. Retrieve all columns for a quick check
SELECT * FROM retail_sales LIMIT 10;

-- 2. Check total number of orders in the dataset
SELECT COUNT(*) AS total_orders FROM retail_sales;

-- 3. Calculate Total Sales and Total Profit
SELECT 
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales;

-- 4. Find the distinct categories available
SELECT DISTINCT category FROM retail_sales;

-- 5. Top 5 Products by Sales Amount
SELECT product_name, ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

-- 6. Sales distribution by Region
SELECT region, COUNT(*) AS num_orders, ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY region
ORDER BY total_sales DESC;

-- 7. Average Order Value (AOV)
SELECT ROUND(AVG(sales), 2) AS avg_order_value FROM retail_sales;

-- 8. Find orders where profit is negative (Loss-making orders)
SELECT order_id, product_name, profit 
FROM retail_sales 
WHERE profit < 0
ORDER BY profit ASC 
LIMIT 10;

-- 9. Total Sales by Year
SELECT YEAR(order_date) AS sales_year, ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY sales_year
ORDER BY sales_year;

-- 10. Monthly Sales Trend (Best for visualization)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month_year, 
    ROUND(SUM(sales), 2) AS monthly_sales
FROM retail_sales
GROUP BY month_year
ORDER BY month_year;

-- 11. Top 3 Categories by Profit
SELECT category, ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC
LIMIT 3;

-- 12. Sales Performance by Ship Mode
SELECT ship_mode, ROUND(SUM(sales), 2) AS total_sales
FROM retail_sales
GROUP BY ship_mode;

-- 13. Find the customer who has spent the most (Customer LTV)
SELECT customer_id, customer_name, ROUND(SUM(sales), 2) AS total_spent
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 14. Count of orders by Day of the Week
SELECT DAYNAME(order_date) AS day_of_week, COUNT(*) AS num_orders
FROM retail_sales
GROUP BY day_of_week
ORDER BY num_orders DESC;

-- 15. Sub-categories with High Sales but Low Profit (Potential issues)
SELECT sub_category, ROUND(SUM(sales), 2) AS total_sales, ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- 16. Products sold in the 'East' region with sales > 500
SELECT product_name, sales, region
FROM retail_sales
WHERE region = 'East' AND sales > 500;

-- 17. Calculate the Profit Margin percentage per Category
SELECT 
    category, 
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY category
ORDER BY profit_margin_percentage DESC;

-- ---------------------------------------------------------
-- ADVANCED ANALYTICS (Window Functions - MySQL 8.0+)
-- ---------------------------------------------------------

-- 18. Running Total of Sales over Time
SELECT 
    order_date, 
    sales, 
    SUM(sales) OVER (ORDER BY order_date) AS running_total
FROM retail_sales
LIMIT 20;

-- 19. Rank Product Sub-Categories by Sales within each Region
SELECT 
    region, 
    sub_category, 
    ROUND(SUM(sales), 2) AS region_sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
FROM retail_sales
GROUP BY region, sub_category;

-- 20. Year-Over-Year Growth (Compare current year sales with previous year)
WITH yearly_sales AS (
    SELECT YEAR(order_date) AS year, SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY year
)
SELECT 
    year, 
    total_sales, 
    LAG(total_sales) OVER (ORDER BY year) AS prev_year_sales,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY year)) / 
          LAG(total_sales) OVER (ORDER BY year) * 100, 2) AS growth_percentage
FROM yearly_sales;