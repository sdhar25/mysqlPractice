create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);


insert into customer_orders values
(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100),
(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700),
(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000)
;


select * from customer_orders;

-- when was the first time each customer has visited  
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id;
-- join with first date visit
WITH first_visit AS (
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id
)
SELECT co.*,fv.first_dt FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id;

-- now we will  check the order_date is matching to our first time--

WITH first_visit AS (
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id
)
SELECT co.*,fv.first_dt,
	CASE WHEN co.order_date=fv.first_dt THEN 1 ELSE 0 END AS  first_visit_flag,
    CASE WHEN co.order_date!=fv.first_dt THEN 1 ELSE 0 END AS  repeat_visit_flag
 FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id;

-- no. of new customer and old customer  by date 

WITH first_visit AS (
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id
),
visit_flag AS
(SELECT co.*,fv.first_dt,
	CASE WHEN co.order_date=fv.first_dt THEN 1 ELSE 0 END AS  first_visit_flag,
    CASE WHEN co.order_date!=fv.first_dt THEN 1 ELSE 0 END AS  repeat_visit_flag
 FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id)
SELECT order_date, sum(first_visit_flag) AS no_of_new_visitors,
sum(repeat_visit_flag) AS no_of_old_visitors
FROM visit_flag 
GROUP BY order_date
;

-- optimizing above code
 
WITH first_visit AS (
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id
)
SELECT co.order_date,
	SUM(CASE WHEN co.order_date=fv.first_dt THEN 1 ELSE 0 END) AS  first_visit_flag,
    SUM(CASE WHEN co.order_date!=fv.first_dt THEN 1 ELSE 0 END) AS  repeat_visit_flag
 FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id
GROUP BY co.order_date;

-- sum of order amount in each day and by old users and new users

WITH first_visit AS (
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id
),
visit_flag AS
(SELECT co.*,fv.first_dt,
	CASE WHEN co.order_date=fv.first_dt THEN 1 ELSE 0 END AS  first_visit_flag,
    CASE WHEN co.order_date!=fv.first_dt THEN 1 ELSE 0 END AS  repeat_visit_flag
 FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id),
amount_sum AS
(
SELECT order_date, sum(order_amount) AS old_customer_order_amount
FROM visit_flag
WHERE first_visit_flag = 1
GROUP BY order_date
)
SELECT vf.order_date, sum(vf.first_visit_flag) AS no_of_new_visitors,
sum(vf.repeat_visit_flag) AS no_of_old_visitors,
asum.old_amount
FROM visit_flag vf
INNER JOIN amount_sum asum ON vf.order_date = asum.order_date
GROUP BY vf.order_date
;

-- try to optimize above code(old amount and new amount)

WITH first_visit AS (
SELECT customer_id, min(order_date) AS first_dt, order_amount
FROM customer_orders
GROUP BY customer_id
)
SELECT co.order_date,
	SUM(CASE WHEN co.order_date=fv.first_dt THEN 1 ELSE 0 END) AS  no_of_new_customer,
    SUM(CASE WHEN co.order_date!=fv.first_dt THEN 1 ELSE 0 END) AS  no_of_old_customer,
    SUM(CASE WHEN co.order_date=fv.first_dt THEN co.order_amount ELSE 0 END) AS  new_customer_order_amount,
    SUM(CASE WHEN co.order_date!=fv.first_dt THEN co.order_amount ELSE 0 END) AS  old_customer_order_amount
 FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id
GROUP BY co.order_date;