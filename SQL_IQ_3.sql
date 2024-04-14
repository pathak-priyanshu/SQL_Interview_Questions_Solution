--------------Interview Questions and solution for Data_Analyst-----------------------------
-- SCHEMA

-- Create the hotel_revenue table
CREATE TABLE hotel_revenue (
    hotel_id INT,
    month VARCHAR(10),
    year INT,
    revenue DECIMAL(10, 2)
);


-- Insert sample records
INSERT INTO hotel_revenue (hotel_id, month, year, revenue) VALUES
(101, 'January', 2022, 15000.50),
(101, 'February', 2022, 18000.75),
(101, 'March', 2022, 20000.00),
(101, 'April', 2022, 20000.00),
(101, 'May', 2022, 20000.00),
(101, 'June', 2022, 20000.00),
(101, 'July', 2022, 26000.00),
(101, 'August', 2022, 28000.00),
(102, 'January', 2022, 12000.25),
(102, 'February', 2022, 14000.50),
(102, 'March', 2022, 16000.75),
(101, 'January', 2023, 17000.25),
(101, 'February', 2023, 19000.50),
(101, 'March', 2023, 21000.75),
(102, 'January', 2023, 13000.50),
(102, 'February', 2023, 15000.75),
(102, 'March', 2023, 17000.25),
(103, 'January', 2022, 11000.25),
(103, 'February', 2022, 13000.50),
(103, 'March', 2022, 15000.75),
(104, 'January', 2022, 14000.50),
(108, 'May', 2022, 31000.75),
(108, 'April', 2022, 28000.75),
(108, 'June', 2022, 16000.75),
(108, 'August', 2022, 16000.75),	
(104, 'March', 2022, 18000.25),
(103, 'January', 2023, 12000.50),
(103, 'February', 2023, 14000.75),
(103, 'March', 2023, 16000.25),
(104, 'January', 2023, 15000.75),
(107, 'February', 2023, 17000.25),
(106, 'March', 2023, 19000.50);


-- Booking.com Data Analyst interview question

/*
Find the top-performing two months 
by revenue for each hotel for each year.
return hotel_id, year, month, revenue
*/
select *
from
(
select hotel_id,[year],[month],DENSE_RANK() over (partition by hotel_id,[year] order by revenue desc) as dnrk,
revenue                                    --#--to get revenue at hotel and at year level we used partition by for both
as total 
from hotel_revenue
group by [month],hotel_id,year ,revenue
) as a
where dnrk <3;
---------------------Method 2 using CTE -------------------------------------------------------------------------
-- using subquerry-----------------------------------------------------------------------------------------------
WITH CTE1
AS
(
	SELECT 
		hotel_id,
		year, 
		month,
		revenue,
		DENSE_RANK() OVER(PARTITION BY hotel_id, year ORDER BY revenue DESC) drn	
	FROM hotel_revenue
)
	
SELECT
	hotel_id,
	year, 
	month,
	revenue
FROM CTE1
WHERE drn <= 2;
----------------------------------------------------------------------------------------------------------------------
/*
Question
Given the employee table with columns EMP_ID and SALARY, 
write an SQL query to find all salaries greater than the average salary.
return emp_id and salary
*/
DROP TABLE IF EXISTS employee;

-- Creating the employee table
CREATE TABLE employee (
    EMP_ID INT PRIMARY KEY,
    SALARY DECIMAL(10, 2)
);

-- Inserting sample data into the employee table
INSERT INTO employee (EMP_ID, SALARY) VALUES
(1, 50000),
(2, 60000),
(3, 70000),
(4, 45000),
(5, 80000),
(6, 55000),
(7, 75000),
(8, 62000),
(9, 48000),
(10, 85000);


select * 
from employee
where SALARY > ( select AVG(SALARY) FROM employee)
----------------------------------------------------------------------------------------------------------------
--# By using CTE we can use alias names inside the subquerry. 
WITH AvgSalary AS (
    SELECT AVG(SALARY) AS AvgSalary
    FROM employee
)
SELECT *
FROM employee
WHERE SALARY > (SELECT AvgSalary FROM AvgSalary);
----------------------------------------------------------------------------------------------------------------------
/*
Consider a table named customers with the following columns: 
customer_id, first_name, last_name, and email. 
Write an SQL query to find all the duplicate email addresses 
in the customers table.*/
-- Creating the customers table
CREATE TABLE customers_demo (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Inserting sample data into the customers table
INSERT INTO customers_demo (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(4, 'Bob', 'Brown', 'bob.brown@example.com'),
(5, 'Emily', 'Davis', 'john.doe@example.com'),
(6, 'Michael', 'Williams', 'michael.w@example.com'),
(7, 'David', 'Wilson', 'jane.smith@example.com'),
(8, 'Sarah', 'Taylor', 'sarah.t@example.com'),
(9, 'James', 'Anderson', 'james.a@example.com'),
(10, 'Laura', 'Martinez', 'laura.m@example.com');

-- email
-- GROUP BY email 
-- HAVING COUNT(email ) > 1
select * from customers_demo
select email,count(email) as email_frq
from customers_demo
group by email
having COUNT(email)>1
---------------------------------------------------------------------------------------------------------------------------
/*
-- Flipkart Business Analyst Interview Question

Question: 
	Write a SQL query to calculate the running 
	total revenue for each combination of date and product ID.

Expected Output Columns: 
	date, product_id, product_name, revenue, running_total
	ORDER BY product_id, date ascending
*/
DROP TABLE IF EXISTS orders;

-- Create the orders table with columns: date, product_id, product_name, and revenue
CREATE TABLE orders (
    date DATE,
    product_id INT,
    product_name VARCHAR(255),
    revenue DECIMAL(10, 2)
);

-- Insert sample data into the orders table representing orders of iPhones
INSERT INTO orders (date, product_id, product_name, revenue) VALUES
('2024-01-01', 101, 'iPhone 13 Pro', 1000.00),
('2024-01-01', 102, 'iPhone 13 Pro Max', 1200.00),
('2024-01-02', 101, 'iPhone 13 Pro', 950.00),
('2024-01-02', 103, 'iPhone 12 Pro', 1100.00),
('2024-01-03', 102, 'iPhone 13 Pro Max', 1250.00),
('2024-01-03', 104, 'iPhone 11', 1400.00),
('2024-01-04', 101, 'iPhone 13 Pro', 800.00),
('2024-01-04', 102, 'iPhone 13 Pro Max', 1350.00),
('2024-01-05', 103, 'iPhone 12 Pro', 1000.00),
('2024-01-05', 104, 'iPhone 11', 700.00),
('2024-01-06', 101, 'iPhone 13 Pro', 600.00),
('2024-01-06', 102, 'iPhone 13 Pro Max', 550.00),
('2024-01-07', 101, 'iPhone 13 Pro', 400.00),
('2024-01-07', 103, 'iPhone 12 Pro', 250.00),
('2024-01-08', 102, 'iPhone 13 Pro Max', 200.00),
('2024-01-08', 104, 'iPhone 11', 150.00),
('2024-01-09', 101, 'iPhone 13 Pro', 100.00),
('2024-01-09', 102, 'iPhone 13 Pro Max', 50.00),
('2024-01-10', 101, 'iPhone 13 Pro', 1000.00),
('2024-01-10', 102, 'iPhone 13 Pro Max', 1200.00),
('2024-01-11', 101, 'iPhone 13 Pro', 950.00),
('2024-01-11', 103, 'iPhone 12 Pro', 1100.00),
('2024-01-12', 102, 'iPhone 13 Pro Max', 1250.00),
('2024-01-12', 104, 'iPhone 11', 1400.00);


select * from orders
SELECT
    date,
    product_id,
    product_name,
    revenue,
    SUM(revenue) OVER (PARTITION BY product_id ORDER BY date) AS running_total
FROM
    orders
ORDER BY
    product_id, date;
-------with the help of joins---------------------------------------------------------
SELECT 
	o1.date,
	o1.product_id,
	o1.product_name,
	o1.revenue,
	SUM(o2.revenue) as running_total
FROM orders as o1
JOIN
orders as o2
ON
	o1.product_id = o2.product_id
	AND
	o1.date >= o2.date
GROUP BY 
	o1.date,
	o1.product_id,
	o1.product_name,
	o1.revenue
ORDER BY 
	o1.product_id, o1.date
