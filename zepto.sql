DROP TABLE IF EXISTS ZEPTO; -- Ran this query to avoid any error before creating the table

CREATE TABLE zepto(
		sku_id SERIAL PRIMARY KEY,
		Category VARCHAR(120),	
		name VARCHAR(120) NOT NULL,
		mrp	NUMERIC(10,2),
		discountPercent	NUMERIC(10,2),
		availableQuantity INT,
		discountedSellingPrice NUMERIC(10,2),	
		weightInGms	INT,
		outOfStock BOOLEAN,
		quantity INT
);

SELECT * FROM zepto;

-- DATA EXPLORATION

-- count of rows
SELECT COUNT(*) FROM zepto;


-- SAMPLE DATA
SELECT * FROM zepto
LIMIT 10;

-- CHECK FOR NULL VALUES;
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;


-- Check different product categories available
SELECT DISTINCT category
FROM zepto
ORDER BY category;


-- Check products which are in stock VS out of stock
SELECT outofstock, count(sku_id) 
FROM zepto
GROUP BY outofstock;

-- Check product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;

SELECT * FROM zepto
WHERE name IN ('Quaker Oats');


-- DATA CLEANING

-- Check for products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;


-- Convert paise into rupees
UPDATE zepto
SET mrp = mrp/100.00,
	discountedsellingprice = discountedsellingprice/100.00;

SELECT * FROM zepto;


-- ANSWERING SOME QUESTIONS TO GET BUSINESS INSIGHTS

-- Q1. Find the top 10 best value products based on the discount percentage
SELECT name, discountpercent, discountedsellingprice 
FROM zepto
ORDER BY discountpercent DESC
limit 10;

-- Q2. What are the products with high mrp but out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;


-- Q3. Calculate estimated revenue for each category
SELECT category, sum(discountedsellingprice*availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;


-- Q4. Find all products where MRP is greater than Rs.500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;


-- Q5. Identify the top 5 categories offering the highest average discount percentage
SELECT category, ROUND(AVG(discountpercent), 2) AS avg_discount_percentage
FROM zepto
GROUP BY category
ORDER BY AVG(discountpercent) DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, discountedsellingprice, weightingms, ROUND(discountedsellingprice/weightingms,2) AS per_per_gram
FROM zepto
WHERE weightingms > 100
ORDER BY per_per_gram;


-- Q7. Group the products into categories like LOW, MEDIUM, BULK.
SELECT distinct name, 
		CASE
			WHEN weightingms <=500 THEN 'Low'
			WHEN weightingms >500 AND weightingms <=2500 THEN 'Medium'
			ELSE 'BULK'
		END AS product_weight_category
FROM zepto
ORDER BY product_weight_category;


-- Q8. What is the total weight per category
SELECT DISTINCT category, SUM(availablequantity*weightingms) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;







