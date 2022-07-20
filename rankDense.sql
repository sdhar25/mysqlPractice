SELECT emp_id,emp_name,department_id,salary,
RANK() OVER(order by salary desc) as rnk,
dense_rank() OVER(order by salary desc) as dns_rnk,
row_number() OVER(order by salary desc) as rn
FROM test2db.emp;

SELECT emp_id,emp_name,department_id,salary,
RANK() OVER(partition by department_id order by salary desc) as rnk,
dense_rank() OVER(partition by department_id order by salary desc) as dns_rnk,
row_number() OVER(partition by department_id order by salary desc) as rn
FROM test2db.emp;

SELECT * FROM (
SELECT emp_id,emp_name,department_id,salary,
RANK() OVER(partition by department_id order by salary desc) as rnk
FROM test2db.emp) AS e
WHERE rnk = 1
;

