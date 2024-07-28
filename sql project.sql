use pizzahut;
select * from orders;
drop table orders;
-- retrive the total no.of orders placed
select count(distinct(order_id)) from orders;
-- calculate the total revenue generated from pizza sales
SELECT o.pizza_id, o.quantity, p.price
FROM order_details o
JOIN pizzas p ON o.pizza_id = p.pizza_id;
select sum(o.quantity*p.price) as total_revenue from order_details o join pizzas p on o.pizza_id=p.pizza_id;
-- Identify the highest-priced pizza.
select * from pizzas;
SELECT p.price, p.pizza_type_id, t.name
FROM pizzas p
JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id;
SELECT  p.price, p.pizza_type_id, t.name
FROM pizzas p
JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id;
SELECT p.pizza_id, t.name, p.price
FROM pizzas p
JOIN pizza_types t ON p.pizza_type_id = t.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
select max(price) from pizzas;
-- Identify the most common pizza size ordered.
SELECT p.size, COUNT(*) AS order_count
FROM order_details o
JOIN pizzas p ON o.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;
select pizzas.size, count(distinct order_id) as 'No of Orders', sum(quantity) as 'Total Quantity Ordered' 
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
-- join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizzas.size
order by count(distinct order_id) desc;
-- Determine the distribution of orders by hour of the day.
SELECT HOUR(time) AS 'Hour of the day', COUNT(DISTINCT order_id) AS 'No of Orders'
FROM orders
GROUP BY HOUR(time)
ORDER BY `No of Orders` DESC;
select * from orders;
-- find the category-wise distribution of pizzas
SELECT category, COUNT(DISTINCT pizza_type_id) AS no_of_pizzas
FROM pizza_types
GROUP BY category
ORDER BY no_of_pizzas;
-- Determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name, SUM(order_details.quantity * pizzas.price) AS `Revenue from pizza`
FROM order_details 
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
JOIN pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY `Revenue from pizza` DESC
LIMIT 3;
--  Determine the top 3 most ordered pizza types based on revenue for each pizza category.

with cte as (
select category, name, cast(sum(quantity*price) as decimal(10,2)) as Revenue
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by category, name
-- order by category, name, Revenue desc
)
, cte1 as (
select category, name, Revenue,
rank() over (partition by category order by Revenue desc) as rnk
from cte 
)
select category, name, Revenue
from cte1 
where rnk in (1,2,3)
order by category, name, Revenue
