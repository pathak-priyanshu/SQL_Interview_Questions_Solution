-- -------------------Interview Questions----------------------------------------------------------------------------------
--DAy5---------------------------------------------------------------------------------------------------------------------
-- Facebook medium level SQL question for Data Analyst -------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
/*
-- Q.1
Question: Identify the top 3 posts with the highest engagement 
(likes + comments) for each user on a Facebook page. Display 
the user ID, post ID, engagement count, and rank for each post.
*/
--  SCHEMAS--------------------------------------------------------------------------------------------------------------------
select * from fb_posts
CREATE TABLE fb_posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    comments INT,
    post_date DATE
);


INSERT INTO fb_posts (post_id, user_id, likes, comments, post_date) VALUES
(1, 101, 50, 20, '2024-02-27'),
(2, 102, 30, 15, '2024-02-28'),
(3, 103, 70, 25, '2024-02-29'),
(4, 101, 80, 30, '2024-03-01'),
(5, 102, 40, 10, '2024-03-02'),
(6, 103, 60, 20, '2024-03-03'),
(7, 101, 90, 35, '2024-03-04'),
(8, 101, 90, 35, '2024-03-05'),
(9, 102, 50, 15, '2024-03-06'),
(10, 103, 30, 10, '2024-03-07'),
(11, 101, 60, 25, '2024-03-08'),
(12, 102, 70, 30, '2024-03-09'),
(13, 103, 80, 35, '2024-03-10'),
(14, 101, 40, 20, '2024-03-11'),
(15, 102, 90, 40, '2024-03-12'),
(16, 103, 20, 5, '2024-03-13'),
(17, 101, 70, 25, '2024-03-14'),
(18, 102, 50, 15, '2024-03-15'),
(19, 103, 30, 10, '2024-03-16'),
(20, 101, 60, 20, '2024-03-17');

-- using cte -------------
WITH rank_posts
AS (
	SELECT 
		user_id,
		post_id,
		SUM(likes + comments) as engagement_count,
		ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY SUM(likes + comments) DESC) rn,
		DENSE_RANK() OVER(PARTITION BY user_id ORDER BY SUM(likes + comments) DESC) ranks
	FROM fb_posts
	GROUP BY user_id, post_id
	)
SELECT 
	user_id,
	post_id,
	engagement_count,
	ranks
FROM rank_posts
WHERE rn <=3
------Method 2 -----------------------------------------------------------------
select * from 
     (select user_id,post_id,sum(likes+comments) as total_count,
     DENSE_RANK() over (partition by user_id order by sum(likes+comments) desc) as drnk,
	 row_number() over (partition by user_id order by sum(likes+comments) desc) as rno
	 from fb_posts
	 group by user_id,post_id ) as a
where drnk <=3 
--Both the querries are correct, give your solution accordingly ----------------------------------------------
/*
-- Q.2

Determine the users who have posted more than 2 times 
in the past week and calculate the total number of likes
they have received. Return user_id and number of post and no of likes
*/
    
	CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    post_date datetime)
;

INSERT INTO posts (post_id, user_id, likes, post_date) VALUES
(1, 101, 50, '2024-02-27'),
(2, 102, 30, '2024-02-28'),
(3, 103, 70, '2024-02-29'),
(4, 101, 80, '2024-02-01'),
(5, 102, 40, '2024-02-02'),
(6, 103, 60, '2024-02-29'),
(7, 101, 90, '2024-01-29'),
(8, 101, 20, '2024-02-05'),
(9, 102, 50, '2024-01-29'),
(10, 103, 30, '2024-02-29'),
(11, 101, 60, '2024-01-08'),
(12, 102, 70, '2024-01-09'),
(13, 103, 80, '2024-01-10'),
(14, 101, 40, '2024-01-29'),
(15, 102, 90, '2024-01-29'),
(16, 103, 20, '2024-01-13'),
(17, 101, 70, '2024-01-14'),
(18, 102, 50, '2024-02-29'),
(19, 103, 30, '2024-02-16'),
(20, 101, 60, '2024-02-17');

select user_id,sum(likes)as no_of_likes,count(post_id) as NO_of_post
from posts
where post_date > (select dateadd(day,-7,max(post_date)) from posts) --'2024-02-22' -- as i am solving this problem in april so i took max of post date and substact 7 days 
group by user_id                                      --from it to get the desired output.
having count(post_id) >2

------------------------------------------------------------------------------------------------------------
-- Zomato Business Analyst interview question 
/*
-- How many delayed orders does each delivery partner have, 
considering the predicted delivery time and the actual delivery time?
*/

CREATE TABLE order_details (
    order_id INT,
    del_partner VARCHAR(255),
    predicted_time datetime,
    delivery_time datetime
);


INSERT INTO order_details (order_id, del_partner, predicted_time, delivery_time) 
VALUES 
    (11, 'Partner C', '2024-02-29 11:30:00', '2024-02-29 12:00:00'),
    (12, 'Partner A', '2024-02-29 10:45:00', '2024-02-29 11:30:00'),
    (13, 'Partner B', '2024-02-29 09:00:00', '2024-02-29 09:45:00'),
    (14, 'Partner A', '2024-02-29 12:15:00', '2024-02-29 13:00:00'),
    (15, 'Partner C', '2024-02-29 13:30:00', '2024-02-29 14:15:00'),
    (16, 'Partner B', '2024-02-29 14:45:00', '2024-02-29 15:30:00'),
    (17, 'Partner A', '2024-02-29 16:00:00', '2024-02-29 16:45:00'),
    (18, 'Partner B', '2024-02-29 17:15:00', '2024-02-29 18:00:00'),
    (19, 'Partner C', '2024-02-29 18:30:00', '2024-02-29 19:15:00');

select del_partner,count(order_id) as DElayed_order
from order_details
where predicted_time < delivery_time
group by del_partner
-------------------------------------------------------------------------------------------------------------
-- SWIGGY BA Interview questions 
/*
Question:
Which metro city had the highest number of restaurant orders in September 2021?
Write the SQL query to retrieve the city name and the total count of orders, 
ordered by the total count of orders in descending order.
-- Note metro cites are 'Delhi', 'Mumbai', 'Bangalore', 'Hyderabad'
*/
-- Create the Table
CREATE TABLE restaurant_orders (
    city VARCHAR(50),
    restaurant_id INT,
    order_id INT,
    order_date DATE
);
-- Insert Records
INSERT INTO restaurant_orders (city, restaurant_id, order_id, order_date)
VALUES
    ('Delhi', 101, 1, '2021-09-05'),
    ('Bangalore', 102, 12, '2021-09-08'),
    ('Bangalore', 102, 13, '2021-09-08'),
    ('Bangalore', 102, 14, '2021-09-08'),
    ('Mumbai', 103, 3, '2021-09-10'),
    ('Mumbai', 103, 30, '2021-09-10'),
    ('Chennai', 104, 4, '2021-09-15'),
    ('Delhi', 105, 5, '2021-09-20'),
    ('Bangalore', 106, 6, '2021-09-25'),
    ('Mumbai', 107, 7, '2021-09-28'),
    ('Chennai', 108, 8, '2021-09-30'),
    ('Delhi', 109, 9, '2021-10-05'),
    ('Bangalore', 110, 10, '2021-10-08'),
    ('Mumbai', 111, 11, '2021-10-10'),
    ('Chennai', 112, 12, '2021-10-15'),
    ('Kolkata', 113, 13, '2021-10-20'),
    ('Hyderabad', 114, 14, '2021-10-25'),
    ('Pune', 115, 15, '2021-10-28'),
    ('Jaipur', 116, 16, '2021-10-30');
--solution -----------------------------------------------------------------------------------------------
select city,count(restaurant_id) as total_orders
from restaurant_orders
where city in ('delhi','mumbai','bangalore','hyderabad')
and
order_date between '2021-09-01' and '2021-09-30'
group by city
order by  total_orders desc
-----------------------------------------------------------------------------------------------
-- Google Interview Question for DA------------------------------------
-- Get the count of distint student that are not unique

CREATE TABLE student_names(
    student_id INT,
    name VARCHAR(50)
);
--Insert the records
INSERT INTO student_names (student_id, name) VALUES
(1, 'RAM'),
(2, 'ROBERT'),
(3, 'ROHIM'),
(4, 'RAM'),
(5, 'ROBERT');
select count (*) as dist_count_stu 
 from (
select distinct (name) 
from student_names) as a
----------------------------------------------------------------------------------------------------------
-- Schemas 
/*
 zomato business analyst interview question
 Find city wise customers count who have placed 
 more than three orders in November 2023.
*/
CREATE TABLE zomato_orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    price FLOAT,
    city VARCHAR(25)
);


-- Insert sample records into the zomato_orders table
INSERT INTO zomato_orders (order_id, customer_id, order_date, price, city) VALUES
(1, 101, '2023-11-01', 150.50, 'Mumbai'),
(2, 102, '2023-11-05', 200.75, 'Delhi'),
(3, 103, '2023-11-10', 180.25, 'Mumbai'),
(4, 104, '2023-11-15', 120.90, 'Delhi'),
(5, 105, '2023-11-20', 250.00, 'Mumbai'),
(6, 108, '2023-11-25', 180.75, 'Gurgoan'),
(7, 107, '2023-12-30', 300.25, 'Delhi'),
(8, 108, '2023-12-02', 220.50, 'Gurgoan'),
(9, 109, '2023-11-08', 170.00, 'Mumbai'),
(10, 110, '2023-10-12', 190.75, 'Delhi'),
(11, 108, '2023-10-18', 210.25, 'Gurgoan'),
(12, 112, '2023-11-24', 280.50, 'Mumbai'),
(13, 113, '2023-10-29', 150.00, 'Mumbai'),
(14, 103, '2023-11-03', 200.75, 'Mumbai'),
(15, 115, '2023-10-07', 230.90, 'Delhi'),
(16, 116, '2023-11-11', 260.00, 'Mumbai'),
(17, 117, '2023-11-16', 180.75, 'Mumbai'),
(18, 102, '2023-11-22', 320.25, 'Delhi'),
(19, 103, '2023-11-27', 170.50, 'Mumbai'),
(20, 102, '2023-11-05', 220.75, 'Delhi'),
(21, 103, '2023-11-09', 300.25, 'Mumbai'), 
(22, 101, '2023-11-15', 180.50, 'Mumbai'), 
(23, 104, '2023-11-18', 250.75, 'Delhi'), 
(24, 102, '2023-11-20', 280.25, 'Delhi'),
(25, 117, '2023-11-16', 180.75, 'Mumbai'),
(26, 117, '2023-11-16', 180.75, 'Mumbai'),
(27, 117, '2023-11-16', 180.75, 'Mumbai'),
(28, 117, '2023-11-16', 180.75, 'Mumbai');
select * from zomato_orders
/*
 zomato business analyst interview question.
 Find city wise customers count who have placed 
 more than three orders in November 2023.
*/
-- summary -- count of customer, filter date nov 2023, group by city
--method 1-- using subquerry-------------
select * from 
(
select city,count(customer_id) as Cust_count
from zomato_orders
where order_date between '2023-11-01' and '2023-11-30'
group by city
) as a
where Cust_count >3
---------------------method 2----------------------
select city,count(customer_id) as Cust_count
from zomato_orders
where order_date between '2023-11-01' and '2023-11-30'
group by city
having count(customer_id)>3;









