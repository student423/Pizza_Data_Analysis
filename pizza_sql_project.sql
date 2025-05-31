CREATE TABLE pizza_orders(
pizza_id INT PRIMARY KEY,	
order_id INT,	
pizza_name_id VARCHAR(50),
quantity INT,	
order_date VARCHAR(20),
order_time TIME,
unit_price FLOAT,
total_price	FLOAT,
pizza_size	VARCHAR(20),
pizza_category VARCHAR(50),
pizza_ingredients VARCHAR(200),
pizza_name VARCHAR(50)
);

## check the values--->
SELECT * FROM pizza_orders;

## check all column we have--->
SELECT COUNT(*) FROM pizza_orders;

## problem statement##

##1. total revenue --->
SELECT SUM(total_price) AS total_revenue FROM pizza_orders;

##2. averg order values--->
SELECT SUM(total_price)/ COUNT(DISTINCT (order_id)) AS avg_odr_values FROM pizza_orders;

##3. total pizza sold--->
SELECT SUM(quantity) AS total_pizza_sold FROM pizza_orders;

##4. total orders---->
SELECT COUNT(DISTINCT(order_id)) AS total_orders FROM pizza_orders;

##5. avrg pizzas per orders---->
SELECT ROUND(SUM(quantity)/ COUNT(DISTINCT(order_id)),2) AS avg_pizza_order FROM pizza_orders;

## i converted date format with yyyy-mm-dd so created new colmn then set values-->

SET SQL_SAFE_UPDATES = 0;    #---> this is safe mode on

ALTER TABLE pizza_orders ADD COLUMN order_date_fixed DATE;

UPDATE pizza_orders  
SET order_date_fixed = STR_TO_DATE(order_date, '%d-%m-%Y');

SELECT order_date_fixed FROM pizza_orders;


##6. daily trends for total orders ----->
SELECT DAYNAME(order_date_fixed) AS orders_day, COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_orders
WHERE order_date_fixed IS NOT NULL
GROUP BY DAYNAME(order_date_fixed)
ORDER BY DAYNAME(order_date_fixed);

##7. hourly trends for total order ----->
SELECT HOUR(order_time) AS total_hour, COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

##8. percentage of sales by pizza quantity---> january month only 
SELECT pizza_category, SUM(total_price) AS total_sales,
ROUND((SUM(total_price)*100)/ (SELECT SUM(total_price) FROM pizza_orders WHERE MONTH(order_date_fixed)=1),2) AS per_sales
FROM pizza_orders
WHERE MONTH(order_date_fixed)=1
GROUP BY pizza_category
ORDER BY per_sales DESC;

##9. % same apply on pizza size--->
SELECT pizza_size, SUM(total_price) AS total_sales,
ROUND((SUM(total_price)*100)/ (SELECT SUM(total_price) FROM pizza_orders WHERE MONTH(order_date_fixed)=1),2) AS per_sales
FROM pizza_orders
WHERE MONTH(order_date_fixed)=1
GROUP BY pizza_size
ORDER BY per_sales DESC;

##10. total pizza sold by pizza quantity----->
SELECT pizza_category, SUM(quantity) AS total_pzza_sold
FROM pizza_orders
GROUP BY pizza_category;

##11.top 5 best seller by  total pizza sold
SELECT pizza_name, SUM(quantity) AS total_pizza_sold
FROM pizza_orders
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC
LIMIT 5;

##12. top 5 bottom seller----->
SELECT pizza_name, SUM(quantity) AS total_pizza_sold
FROM pizza_orders
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC
LIMIT 5;

##13. top 5 best seller on august month--->
SELECT pizza_name, SUM(quantity) AS total_pizza_sold
FROM pizza_orders
WHERE MONTH(order_date_fixed)=7
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC
LIMIT 5;

##14 top 10 bottom seller on oct month---->
SELECT pizza_name, SUM(quantity) AS total_pizza_sold
FROM pizza_orders
WHERE MONTH(order_date_fixed)=9
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC
LIMIT 10;

