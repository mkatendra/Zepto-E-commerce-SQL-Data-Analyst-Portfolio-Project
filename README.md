🛒 Zepto E-commerce SQL Data Analyst Portfolio Project
This is a complete, real-world data analyst portfolio project based on an e-commerce inventory dataset scraped from Zepto — one of India’s fastest-growing quick-commerce startups. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.
📌 Project Overview
The goal is to simulate how actual data analysts in the e-commerce or retail industries work behind the scenes to use SQL to:

✅ Set up a messy, real-world e-commerce inventory database

✅ Perform Exploratory Data Analysis (EDA) to explore product categories, availability, and pricing inconsistencies

✅ Implement Data Cleaning to handle null values, remove invalid entries, and convert pricing from paise to rupees

✅ Write business-driven SQL queries to derive insights around pricing, inventory, stock availability, revenue and more

📁 Dataset Overview
The dataset was sourced from Kaggle and was originally scraped from Zepto’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility, exactly how real catalogue data looks. 

🧾 Columns:

sku_id: Unique identifier for each product entry (Synthetic Primary Key)

name: Product name as it appears on the app

category: Product category like Fruits, Snacks, Beverages, etc.

mrp: Maximum Retail Price (originally in paise, converted to ₹)

discountPercent: Discount applied on MRP

discountedSellingPrice: Final price after discount (also converted to ₹)

availableQuantity: Units available in inventory

weightInGms: Product weight in grams

outOfStock: Boolean flag indicating stock availability

quantity: Number of units per package (mixed with grams for loose produce)
🔧 Project Workflow
Here’s a step-by-step breakdown of what we do in this project:

1. Database & Table Creation
We start by creating a SQL table with appropriate data types:
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
2. Data Import
Loaded CSV using pgAdmin's import feature.
   \copy zepto(category,name,mrp,discountPercent,availableQuantity,
            discountedSellingPrice,weightInGms,outOfStock,quantity)
  FROM 'data/zepto_v2.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');
3. 🔍 Data Exploration
Counted the total number of records in the dataset

Viewed a sample of the dataset to understand the structure and content 

Checked for null values across all columns

Identified distinct product categories available in the dataset

Compared in-stock vs out-of-stock product counts

Detected products present multiple times, representing different SKUs
4. 🧹 Data Cleaning
Identified and removed rows where MRP or the discounted selling price was zero 

Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability
5. 📊 Business Insights
5.1 Found the top 10 best-value products based on discount percentage
SELECT name, discountpercent, discountedsellingprice 
FROM zepto
ORDER BY discountpercent DESC
limit 10; 

5.2 Identified high-MRP products that are currently out of stock 

SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;

5.3 Estimated potential revenue for each product category 

SELECT category, sum(discountedsellingprice*availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

5.4 Filtered expensive products (MRP > ₹500) with minimal discount 

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

5.5 Ranked top 5 categories offering the highest average discounts 

SELECT category, ROUND(AVG(discountpercent), 2) AS avg_discount_percentage
FROM zepto
GROUP BY category
ORDER BY AVG(discountpercent) DESC
LIMIT 5;

5.6 Calculated price per gram to identify value-for-money products 

SELECT DISTINCT name, discountedsellingprice, weightingms, ROUND(discountedsellingprice/weightingms,2) AS per_per_gram
FROM zepto
WHERE weightingms > 100
ORDER BY per_per_gram;

5.7 Grouped products based on weight into Low, Medium, and Bulk categories 
SELECT distinct name, 
		CASE
			WHEN weightingms <=500 THEN 'Low'
			WHEN weightingms >500 AND weightingms <=2500 THEN 'Medium'
			ELSE 'BULK'
		END AS product_weight_category
FROM zepto
ORDER BY product_weight_category;


5.8 Measured total inventory weight per product category
SELECT DISTINCT category, SUM(availablequantity*weightingms) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
