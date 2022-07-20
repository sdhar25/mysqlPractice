create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);

INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

SELECT * FROM icc_world_cup;

SELECT team_name, COUNT(1) AS no_of_matches_played, SUM(wnflg) AS no_of_matches_won, COUNT(1)- SUM(wnflg) AS no_of_losses
 FROM(
SELECT Team_1 AS team_name, CASE  when Team_1 = Winner THEN 1 ELSE 0 END AS wnflg FROM icc_world_cup
UNION ALL
SELECT Team_2 AS team_name, CASE when Team_2 = Winner Then 1 ELSE 0 END AS wnflg FROM icc_world_cup
) AS cmbTbl
GROUP BY team_name
ORDER BY no_of_matches_won desc


 