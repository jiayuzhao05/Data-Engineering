# Midterm

# 1.1
SELECT Branch, SUM(Total_Amount) AS total_sales
FROM supermarket_sales
GROUP BY Branch
ORDER BY total_sales DESC;

# 1.2
SELECT Product_Line, SUM(Total_Amount) AS total_sales
FROM supermarket_sales
GROUP BY Product_Line
ORDER BY total_sales DESC;

# 1.3
SELECT AVG(Total_Amount) AS avg_sales_per_transaction
FROM supermarket_sales;

# 2.1
SELECT "Customer type", COUNT(DISTINCT Customer_ID) AS unique_customers
FROM supermarket_sales
GROUP BY "Customer type";

# 2.2
SELECT Customer_ID, First_Name, Last_Name, SUM(Total_Amount) AS total_spent
FROM supermarket_sales
GROUP BY Customer_ID, First_Name, Last_Name
ORDER BY total_spent DESC
LIMIT 5;

# 2.3
SELECT AVG(Total_Amount) AS avg_vip_transaction
FROM supermarket_sales
WHERE "Customer type" = 'VIP';

# 3.1
SELECT Product_Line, AVG(CAST(Quantity AS INT)) AS avg_quantity_sold
FROM supermarket_sales
GROUP BY Product_Line;

# 3.2
SELECT Product_ID, SUM(CAST(Quantity AS INT)) AS total_quantity_sold
FROM supermarket_sales
GROUP BY Product_ID
ORDER BY total_quantity_sold DESC
LIMIT 3;

# 3.3
SELECT Product_Line, SUM(Total_Amount) AS total_revenue
FROM supermarket_sales
GROUP BY Product_Line
ORDER BY total_revenue DESC;

# 4.1
SELECT Product_ID, Product_Line, SUM(CAST(Quantity AS INT)) AS total_quantity_sold
FROM supermarket_sales
GROUP BY Product_ID, Product_Line
HAVING total_quantity_sold < 10;

# 4.2
SELECT Product_ID, SUM(CAST(Quantity AS INT)) AS total_units_sold
FROM supermarket_sales
GROUP BY Product_ID
ORDER BY total_units_sold DESC;

# 4.3
SELECT Product_ID, AVG(CAST(Quantity AS INT)) AS avg_quantity_per_sale
FROM supermarket_sales
GROUP BY Product_ID
ORDER BY avg_quantity_per_sale DESC
LIMIT 1;

# 5.1
SELECT Payment, COUNT(*) AS transaction_count
FROM supermarket_sales
GROUP BY Payment
ORDER BY transaction_count DESC;

# 5.2
SELECT Payment, SUM(Total_Amount) AS total_sales
FROM supermarket_sales
GROUP BY Payment
ORDER BY total_sales DESC;

# 5.3
SELECT Payment, AVG(Total_Amount) AS avg_sales_per_transaction
FROM supermarket_sales
GROUP BY Payment
ORDER BY avg_sales_per_transaction DESC;

# 6.1
SELECT 
  EXTRACT(MONTH FROM Date) AS sale_month,
  SUM(Total_Amount) AS total_sales
FROM supermarket_sales
GROUP BY sale_month
ORDER BY sale_month;

# 6.2
SELECT 
  EXTRACT(HOUR FROM Date) AS sale_hour,
  COUNT(*) AS transaction_count
FROM supermarket_sales
GROUP BY sale_hour
ORDER BY transaction_count DESC
LIMIT 1;

# 6.3
SELECT 
  TO_CHAR(Date, 'Day') AS day_of_week,
  AVG(Total_Amount) AS avg_sales
FROM supermarket_sales
GROUP BY day_of_week
ORDER BY avg_sales DESC;

# 7.1
SELECT Branch, SUM(Total_Amount) AS total_sales
FROM supermarket_sales
GROUP BY Branch
ORDER BY total_sales DESC;

# 7.2
SELECT Branch, AVG(CAST(Rating AS FLOAT)) AS avg_rating
FROM supermarket_sales
GROUP BY Branch
ORDER BY avg_rating DESC;

# 7.3
SELECT City, AVG(Total_Amount) AS avg_sales
FROM supermarket_sales
GROUP BY City
ORDER BY avg_sales DESC;

# 8.1
SELECT 
  SUM(Total_Amount) AS total_sales,
  SUM(cogs) AS total_cost,
  SUM(Total_Amount - cogs) AS total_profit
FROM supermarket_sales;

# 8.2
SELECT 
  Branch, 
  Product_Line, 
  AVG(CAST(Rating AS FLOAT)) AS avg_rating
FROM supermarket_sales
GROUP BY Branch, Product_Line
ORDER BY avg_rating DESC;

# 8.3
SELECT Branch, SUM(Total_Amount - cogs) AS total_profit
FROM supermarket_sales
GROUP BY Branch
ORDER BY total_profit DESC
LIMIT 1;

# 9.1
SELECT 
  Customer_ID, 
  COUNT(*) AS purchase_count
FROM supermarket_sales
GROUP BY Customer_ID
ORDER BY purchase_count DESC;

# 9.2
SELECT 
  "Customer type", 
  AVG(Total_Amount) AS avg_spent
FROM supermarket_sales
GROUP BY "Customer type"
ORDER BY avg_spent DESC;


# 9.3
SELECT 
  "Customer type", 
  AVG(CAST(Quantity AS INT)) AS avg_items_per_transaction
FROM supermarket_sales
GROUP BY "Customer type"
ORDER BY avg_items_per_transaction DESC;

# 10.1
SELECT 
  Product_ID,
  Product_Line,
  SUM(Total_Amount - cogs) / SUM(Total_Amount) AS profit_margin
FROM supermarket_sales
GROUP BY Product_ID, Product_Line
ORDER BY profit_margin DESC;

# 10.2
SELECT 
  Product_ID,
  Product_Line,
  Unit_Price,
  Quantity,
  Unit_Price * CAST(Quantity AS FLOAT) * 0.05 AS tax_amount
FROM supermarket_sales;

# 10.3
SELECT 
  Product_Line,
  AVG((Total_Amount - cogs) / NULLIF(Total_Amount, 0)) AS avg_profit_margin
FROM supermarket_sales
GROUP BY Product_Line
ORDER BY avg_profit_margin DESC
LIMIT 1;
