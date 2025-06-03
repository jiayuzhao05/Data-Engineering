
--- FIRST SET OF EXAMPLES

create database wind_func; 

use wind_func;

--- https://www.mysqltutorial.org/mysql-window-functions/

CREATE TABLE wind_func.sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);

SELECT * FROM sales;

INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

commit;

SELECT * FROM sales;


SELECT 
    SUM(sale)
FROM
    sales;
    
    SELECT 
    fiscal_year, 
    SUM(sale)
FROM
    sales
GROUP BY 
    fiscal_year;
    
    SELECT 
    fiscal_year, 
    sales_employee,
    sale,
    SUM(sale) OVER (PARTITION BY fiscal_year) total_sales
FROM
    sales;

--- https://www.mysqltutorial.org/mysql-basics/mysql-rollup/

SELECT 
    sales_employee,
    fiscal_year, 
    SUM(sale)
FROM
    wind_func.sales
GROUP BY 
    sales_employee,
    fiscal_year
    WITH ROLLUP
;
    
--- https://dev.mysql.com/doc/refman/8.4/en/window-functions-usage.html
    
CREATE TABLE wind_func.sales_2(
    product VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    profit DECIMAL(14,2) NOT NULL,
    country VARCHAR(50) NOT NULL
);
	
INSERT INTO sales_2(year,country, product,profit)
VALUES (2000, 'Finland', 'Computer', 1500);
commit;
select * from sales_2;

INSERT INTO sales_2(year,country, product,profit)
VALUES 
(2000, 'Finland', 'Computer', 1500),
(2000 ,'Finland', 'Phone',100 ),
( 2001 ,'Finland', 'Phone',10 ),
( 2000 ,'India', 'Calculator',75 ),
( 2000 ,'India', 'Calculator',75 ),
( 2000 ,'India', 'Computer',1200 ),
( 2000 ,'USA', 'Calculator',75 ),
( 2000 ,'USA', 'Computer',1500 ),
( 2001 ,'USA', 'Calculator',50 ),
( 2001 ,'USA', 'Computer',1500 ),
( 2001 ,'USA', 'Computer',1200 ),
( 2001 ,'USA', 'TV ', 150 ),
( 2001 ,'USA', 'TV',100 )
;

commit;

truncate sales_2;

select * from sales_2;

SELECT SUM(profit) AS total_profit
       FROM sales_2;
       
       SELECT country, SUM(profit) AS country_profit
       FROM sales_2
       GROUP BY country
       ORDER BY country;
       
SELECT
         year, country, product, profit,
         SUM(profit) OVER() AS total_profit,
         SUM(profit) OVER(PARTITION BY country) AS country_profit
       FROM sales_2
       ORDER BY country, year, product, profit;
       
SELECT
         year, country, product, profit,
         ROW_NUMBER() OVER(PARTITION BY country) AS row_num1,
         ROW_NUMBER() OVER(PARTITION BY country ORDER BY year, product) AS row_num2
       FROM sales_2;

--- https://dev.mysql.com/doc/refman/8.4/en/group-by-modifiers.html

SELECT year, SUM(profit) AS profit
FROM sales_2
GROUP BY year WITH ROLLUP;

SELECT year, country, product, SUM(profit) AS profit
FROM sales_2
GROUP BY year, country, product;

SELECT year, country, product, SUM(profit) AS profit
FROM sales_2
GROUP BY year, country, product WITH ROLLUP;

SELECT
year, country, product, SUM(profit) AS profit,
GROUPING(year) AS grp_year,
GROUPING(country) AS grp_country,
GROUPING(product) AS grp_product
FROM sales_2
GROUP BY year, country, product WITH ROLLUP;


SELECT
IF(GROUPING(year), 'All years', year) AS year,
IF(GROUPING(country), 'All countries', country) AS country,
IF(GROUPING(product), 'All products', product) AS product,
SUM(profit) AS profit
FROM sales_2
GROUP BY year, country, product WITH ROLLUP;

SELECT year, SUM(profit) AS profit
FROM sales_2
GROUP BY year WITH ROLLUP
ORDER BY GROUPING(year) DESC;

SELECT year, country, product, SUM(profit) AS profit
FROM sales_2
GROUP BY year, country, product WITH ROLLUP
LIMIT 5;

--- SECOND SET OF EXAMPLES


-- Create a new example database
CREATE DATABASE IF NOT EXISTS salesdb;
USE salesdb;

-- Create tables for the example database
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert expanded sample data into Employees table
INSERT INTO Employees (EmployeeID, EmployeeName, Department, Salary) VALUES
(1, 'Alice', 'HR', 55000),
(2, 'Bob', 'Sales', 62000),
(3, 'Charlie', 'IT', 68000),
(4, 'David', 'Sales', 59000),
(5, 'Emma', 'IT', 71000),
(6, 'Frank', 'HR', 60000),
(7, 'Grace', 'Finance', 75000),
(8, 'Hannah', 'Finance', 72000),
(9, 'Ian', 'IT', 69000),
(10, 'Jack', 'Sales', 58000),
(11, 'Kate', 'HR', 57000),
(12, 'Liam', 'Finance', 80000),
(13, 'Mia', 'IT', 67000),
(14, 'Noah', 'Sales', 61000),
(15, 'Olivia', 'HR', 59000);

commit;

-- Insert expanded sample data into Sales table (100 rows)
INSERT INTO Sales (SaleID, EmployeeID, SaleAmount, SaleDate) VALUES
(1, 2, 500, '2024-10-01'),
(2, 2, 700, '2024-10-05'),
(3, 4, 300, '2024-10-02'),
(4, 4, 900, '2024-10-06'),
(5, 2, 400, '2024-10-10'),
(6, 4, 600, '2024-10-10'),
(7, 2, 1000, '2024-10-15'),
(8, 10, 450, '2024-10-04'),
(9, 10, 550, '2024-10-07'),
(10, 14, 700, '2024-10-03'),
(11, 14, 800, '2024-10-08'),
(12, 14, 650, '2024-10-12'),
(13, 14, 900, '2024-10-17'),
(14, 4, 750, '2024-10-15'),
(15, 2, 850, '2024-10-18'),
(16, 4, 500, '2024-10-20'),
(17, 10, 600, '2024-10-22'),
(18, 4, 1000, '2024-10-25'),
(19, 14, 400, '2024-10-27'),
(20, 2, 950, '2024-10-28'),
(21, 5, 700, '2024-10-01'),
(22, 3, 650, '2024-10-03'),
(23, 1, 500, '2024-10-05'),
(24, 7, 800, '2024-10-06'),
(25, 8, 600, '2024-10-09'),
(26, 6, 550, '2024-10-11'),
(27, 9, 750, '2024-10-12'),
(28, 11, 700, '2024-10-15'),
(29, 13, 600, '2024-10-16'),
(30, 12, 900, '2024-10-19'),
(31, 1, 400, '2024-10-20'),
(32, 15, 950, '2024-10-22'),
(33, 7, 850, '2024-10-24'),
(34, 5, 700, '2024-10-25'),
(35, 3, 800, '2024-10-26'),
(36, 8, 1000, '2024-10-27'),
(37, 6, 900, '2024-10-29'),
(38, 9, 450, '2024-10-30'),
(39, 13, 550, '2024-10-31'),
(40, 11, 750, '2024-11-01'),
(41, 1, 850, '2024-11-02'),
(42, 2, 950, '2024-11-03'),
(43, 10, 900, '2024-11-04'),
(44, 4, 600, '2024-11-05'),
(45, 14, 800, '2024-11-06'),
(46, 5, 500, '2024-11-07'),
(47, 3, 650, '2024-11-08'),
(48, 12, 700, '2024-11-09'),
(49, 15, 750, '2024-11-10'),
(50, 6, 850, '2024-11-11'),
(51, 8, 950, '2024-11-12'),
(52, 9, 550, '2024-11-13'),
(53, 11, 800, '2024-11-14'),
(54, 13, 650, '2024-11-15'),
(55, 7, 400, '2024-11-16'),
(56, 2, 500, '2024-11-17'),
(57, 4, 700, '2024-11-18'),
(58, 10, 850, '2024-11-19'),
(59, 1, 950, '2024-11-20'),
(60, 3, 550, '2024-11-21'),
(61, 12, 600, '2024-11-22'),
(62, 14, 700, '2024-11-23'),
(63, 11, 800, '2024-11-24'),
(64, 8, 900, '2024-11-25'),
(65, 15, 450, '2024-11-26'),
(66, 5, 550, '2024-11-27'),
(67, 13, 650, '2024-11-28'),
(68, 6, 750, '2024-11-29'),
(69, 9, 850, '2024-11-30'),
(70, 7, 950, '2024-12-01'),
(71, 4, 700, '2024-12-02'),
(72, 10, 500, '2024-12-03'),
(73, 2, 650, '2024-12-04'),
(74, 1, 800, '2024-12-05'),
(75, 14, 900, '2024-12-06'),
(76, 12, 400, '2024-12-07'),
(77, 11, 500, '2024-12-08'),
(78, 15, 600, '2024-12-09'),
(79, 9, 700, '2024-12-10'),
(80, 8, 750, '2024-12-11'),
(81, 7, 800, '2024-12-12'),
(82, 6, 900, '2024-12-13'),
(83, 3, 950, '2024-12-14'),
(84, 5, 550, '2024-12-15'),
(85, 13, 450, '2024-12-16'),
(86, 10, 650, '2024-12-17'),
(87, 14, 750, '2024-12-18'),
(88, 12, 850, '2024-12-19'),
(89, 1, 500, '2024-12-20'),
(90, 2, 700, '2024-12-21'),
(91, 4, 900, '2024-12-22'),
(92, 5, 600, '2024-12-23'),
(93, 3, 800, '2024-12-24'),
(94, 11, 400, '2024-12-25'),
(95, 15, 950, '2024-12-26'),
(96, 6, 650, '2024-12-27'),
(97, 9, 750, '2024-12-28'),
(98, 8, 850, '2024-12-29'),
(99, 13, 550, '2024-12-30'),
(100, 7, 450, '2024-12-31');

-- Example Questions and Answers using Window Functions
-- Q1: Calculate the running total of sales for each employee.
SELECT 
    EmployeeID, 
    SaleDate, 
    SaleAmount, 
    SUM(SaleAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS RunningTotal
FROM Sales
ORDER BY EmployeeID, SaleDate;

-- Q2: Find the average salary for each department.
SELECT 
    Department, 
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY Department;

-- Q3: Find the cumulative sales amount for each employee ordered by sale date
SELECT 
    EmployeeID, 
    SaleDate, 
    SaleAmount, 
    SUM(SaleAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS CumulativeSales
FROM Sales
ORDER BY EmployeeID, SaleDate;

-- Q4: Rank employees based on their total salary within each department
SELECT 
    EmployeeID, 
    EmployeeName, 
    Department, 
    Salary, 
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DepartmentRank
FROM Employees
ORDER BY Department, DepartmentRank;

-- Q5: Find the moving average of sales amount for each employee over the last 3 sales
SELECT 
    EmployeeID, 
    SaleDate, 
    SaleAmount,
    AVG(SaleAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate ROWS 2 PRECEDING) AS MovingAvg
FROM Sales
ORDER BY EmployeeID, SaleDate;

-- Q6: Calculate the percent rank of each employee's salary within the company
SELECT 
    EmployeeID, 
    EmployeeName, 
    Salary, 
    PERCENT_RANK() OVER (ORDER BY Salary) AS SalaryPercentRank
FROM Employees
ORDER BY Salary;

-- Q7: Find the difference between each employee's salary and the maximum salary in the department
SELECT 
    EmployeeID, 
    EmployeeName, 
    Department, 
    Salary, 
    MAX(Salary) OVER (PARTITION BY Department) - Salary AS SalaryDifference
FROM Employees
ORDER BY Department, Salary;
