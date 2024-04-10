-- -------------------Interview Questions--------------------------
-- Amazon Interview Question for enty Business Analyst!
-- ---------------------------------------------
/*
Question:: Given the reviews table, write a query to retrieve 
the average star rating for each product, grouped by month. 
The output should display the month as a numerical value, 
product ID, and average star rating rounded to two decimal places. 
Sort the output first by month and then by product ID.
*/
-- avg of star, group by months,product_id,
CREATE TABLE reviews (
    review_id INTEGER,
    user_id INTEGER,
    submit_date datetime,
    product_id INTEGER,
    stars INTEGER
);

INSERT INTO reviews (review_id, user_id, submit_date, product_id, stars) VALUES
(6171, 123, '2022-06-08 00:00:00', 50001, 4),
(7802, 265, '2022-06-10 00:00:00', 69852, 4),
(5293, 362, '2022-06-18 00:00:00', 50001, 3),
(6352, 192, '2022-07-26 00:00:00', 69852, 3),
(4517, 981, '2022-07-05 00:00:00', 69852, 2),
(8654, 753, '2022-08-15 00:00:00', 50001, 5),
(9743, 642, '2022-08-22 00:00:00', 69852, 3),
(1025, 874, '2022-08-05 00:00:00', 50001, 4),
(2089, 512, '2022-09-10 00:00:00', 69852, 2),
(3078, 369, '2022-09-18 00:00:00', 50001, 5),
(4056, 785, '2022-09-25 00:00:00', 69852, 4),
(5034, 641, '2022-10-12 00:00:00', 50001, 3),
(6023, 829, '2022-10-18 00:00:00', 69852, 5),
(7012, 957, '2022-10-25 00:00:00', 50001, 2),
(8001, 413, '2022-11-05 00:00:00', 69852, 4),
(8990, 268, '2022-11-15 00:00:00', 50001, 3),
(9967, 518, '2022-11-22 00:00:00', 69852, 3),
(1086, 753, '2022-12-10 00:00:00', 50001, 5),
(1175, 642, '2022-12-18 00:00:00', 69852, 4),
(1264, 874, '2022-12-25 00:00:00', 50001, 3),
(1353, 512, '2022-12-31 00:00:00', 69852, 2),
(1442, 369, '2023-01-05 00:00:00', 50001, 4),
(1531, 785, '2023-01-15 00:00:00', 69852, 5),
(1620, 641, '2023-01-22 00:00:00', 50001, 3),
(1709, 829, '2023-01-30 00:00:00', 69852, 4);

select * from reviews


select month(submit_date) as month_num,product_id,avg(stars) as avg_str
from reviews
group by month(submit_date),product_id 
order by month(submit_date),product_id;
----------------------------------------------------------------------------------------------------------------------
/*
SQL Question 1: Identify IBM's High Capacity Users

SQL Question: 
Identify users who have made purchases 
totaling more than $10,000 in the last month 
from the purchases table. 
The table contains information about purchases, 
including the user ID, date of purchase, product ID, 
and amount spent.
*/
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    date_of_purchase datetime,
    product_id INT,
    amount_spent DECIMAL(10, 2)
);

INSERT INTO purchases (purchase_id, user_id, date_of_purchase, product_id, amount_spent) VALUES
(2171, 145, '2024-02-22 00:00:00', 43001, 1000),
(3022, 578, '2024-02-24 00:00:00', 25852, 4000),
(4933, 145, '2024-02-28 00:00:00', 43001, 7000),
(6322, 248, '2024-02-19 00:00:00', 25852, 2000),
(4717, 578, '2024-02-12 00:00:00', 25852, 7000),
(2172, 145, '2024-01-15 00:00:00', 43001, 8000),
(3023, 578, '2024-01-18 00:00:00', 25852, 3000),
(4934, 145, '2024-01-28 00:00:00', 43001, 9000),
(6323, 248, '2024-02-20 00:00:00', 25852, 1500),
(4718, 578, '2024-02-25 00:00:00', 25852, 6000);
select * from  purchases

     

select [user_id],sum(amount_spent) as total
from purchases
where month(date_of_purchase)=2
group by [user_id]
having sum(amount_spent)>10000;
-----------------------------------------------------------
/*
You have a table named employees containing information about employees, 
including their emp_id, name, and manager_id. 
The manager_id refers to the emp_id of the employee's manager.

*/
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);
select * from employees

INSERT INTO employees (emp_id, name, manager_id) VALUES
(1, 'John Doe', NULL),        -- John Doe is not a manager
(2, 'Jane Smith', 1),          -- Jane Smith's manager is John Doe
(3, 'Alice Johnson', 1),       -- Alice Johnson's manager is John Doe
(4, 'Bob Brown', 3),           -- Bob Brown's manager is Alice Johnson
(5, 'Emily White', NULL),      -- Emily White is not a manager
(6, 'Michael Lee', 3),         -- Michael Lee's manager is Alice Johnson
(7, 'David Clark', NULL),      -- David Clark is not a manager
(8, 'Sarah Davis', 2),         -- Sarah Davis's manager is Jane Smith
(9, 'Kevin Wilson', 2),        -- Kevin Wilson's manager is Jane Smith
(10, 'Laura Martinez', 4);     -- Laura Martinez's manager is Bob Brown
--write a SQL query to retrieve all employees' details along with their manager's names based on the manager ID
select e.*, m.name as manager_name
from employees e
cross join employees m 
where e.manager_id=m.emp_id 
select * from employees

-- Write a SQL query to find the names of all employees who are also managers.
select distinct(e.name)
from employees e
join employees m on e.emp_id=m.manager_id
--or --
SELECT e.name AS employee_name
FROM employees e
JOIN employees m ON e.emp_id = m.manager_id;


