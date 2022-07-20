create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries values 
('A','Bangalore','A@gmail.com',1,'CPU'),
('A','Bangalore','A1@gmail.com',1,'CPU'),
('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
('B','Bangalore','B@gmail.com',2,'DESKTOP'),
('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
('B','Bangalore','B2@gmail.com',1,'MONITOR');

SELECT * FROM entries;


With 
dist_resource AS(
select distinct name,  resources from entries
),
agg_dis_resc AS (
SELECT name, GROUP_CONCAT(resources) AS used_res
FROM dist_resource group by name
),
total_visit AS(
SELECT name,count(name) AS total_visit FROM entries
GROUP BY name
),
floor_highest_visited AS(
SELECT name,floor,count(floor),
rank() over(partition by name order by count(name) desc) AS rn
FROM entries
GROUP BY name, floor
)
SELECT a.name,tv.total_visit,f.floor AS most_visitedFloor,a.used_res FROM agg_dis_resc a
INNER JOIN floor_highest_visited f ON f.name = a.name
INNER JOIN  total_visit tv ON tv.name = a.name
WHERE f.rn=1;






