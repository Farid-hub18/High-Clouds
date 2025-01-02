Select * from projects;

Create database High_Cloud_Airlines;
Select * from maindata;
SHOW COLUMNS FROM maindata;


ALTER TABLE maindata CHANGE COLUMN `Month (#)` month_no INT;


CREATE TABLE calendar_table
 (
    calendar_date DATE ,
    year INT,
    month_no INT,
    month_fullname VARCHAR(20),
    quarter_ VARCHAR(2),
    year_month_ VARCHAR(10),
    weekday_no INT,
    weekday_name VARCHAR(20),
    financial_month VARCHAR(6),
    financial_quarter VARCHAR(6)
);
ALTER TABLE calendar_table 
MODIFY year_month_ VARCHAR(10);

INSERT INTO calendar_table (
    calendar_date, 
    year, 
    month_no, 
    month_fullname, 
    quarter_, 
    year_month_, 
    weekday_no, 
    weekday_name, 
    financial_month, 
    financial_quarter
)
SELECT 
    STR_TO_DATE(CONCAT(year, '-', month_no, '-', day), '%Y-%m-%d') AS calendar_date,
    year AS year,
    month_no AS month_no,
    MONTHNAME(STR_TO_DATE(CONCAT(year, '-', month_no, '-', day), '%Y-%m-%d')) AS month_fullname,
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(year, '-', month_no, '-', day), '%Y-%m-%d'))) AS quarter_,
    DATE_FORMAT(STR_TO_DATE(CONCAT(year, '-', month_no, '-', day), '%Y-%m-%d'), '%Y-%b') AS year_month_,
    DAYOFWEEK(STR_TO_DATE(CONCAT(year, '-', month_no, '-', day), '%Y-%m-%d')) AS weekday_no,
    DAYNAME(STR_TO_DATE(CONCAT(year, '-', month_no, '-', day), '%Y-%m-%d')) AS weekday_name,
    CASE 
        WHEN month_no = 4 THEN 'FM1' 
        WHEN month_no = 5 THEN 'FM2' 
        WHEN month_no = 6 THEN 'FM3' 
        WHEN month_no = 7 THEN 'FM4' 
        WHEN month_no = 8 THEN 'FM5' 
        WHEN month_no = 9 THEN 'FM6' 
        WHEN month_no = 10 THEN 'FM7' 
        WHEN month_no = 11 THEN 'FM8' 
        WHEN month_no = 12 THEN 'FM9' 
        WHEN month_no = 1 THEN 'FM10' 
        WHEN month_no = 2 THEN 'FM11' 
        WHEN month_no = 3 THEN 'FM12' 
    END AS financial_month,
    CASE 
        WHEN month_no IN (4, 5, 6) THEN 'FQ1'
        WHEN month_no IN (7, 8, 9) THEN 'FQ2'
        WHEN month_no IN (10, 11, 12) THEN 'FQ3'
        WHEN month_no IN (1, 2, 3) THEN 'FQ4'
    END AS financial_quarter
FROM 
    maindata
WHERE 
    year IS NOT NULL AND 
    month_no IS NOT NULL AND 
    day IS NOT NULL;

DESCRIBE maindata;
select * from maindata;

# Answer 1
Select * from calendar_table;

#Answer 2 Find the load Factor percentage on a yearly , 
-- Quarterly , Monthly basis ( Transported passengers / Available seats)
SELECT 
    `year` AS year,  
    QUARTER(STR_TO_DATE(CONCAT(`year`, '-', LPAD(`Month_no`, 2, '0'), '-01'), '%Y-%m-%d')) AS quarter, 
    `Month_no` AS month,  
    sum(`# Transported Passengers`) AS total_passengers,
    sum(`# Available Seats`) AS total_available_seats,
    (sum(`# Transported Passengers`) / sum(`# Available Seats`)) * 100 AS load_factor_percentage
FROM 
    maindata
GROUP BY 
    `year`,
    QUARTER(STR_TO_DATE(CONCAT(`year`, '-', LPAD(`Month_no`, 2, '0'), '-01'), '%Y-%m-%d')),  
    `Month_no`
ORDER BY 
    `year`, quarter, `month`;

#Answer 3 Find the load Factor percentage on a Carrier Name basis 
#( Transported passengers / Available seats)

Select `Carrier name` ,
sum(`# Transported passengers`) As total_passengers,
sum(`# Available seats`) As total_available_seats,
(sum(`# Transported passengers`) / sum(`# Available seats`)) * 100 As load_factor_percentage
from maindata
group By
`Carrier name`;

#Answer 4. Identify Top 10 Carrier Names based on passengers preference 
Select `Carrier name`,
sum(`# Transported passengers`) As Total_passengers
from maindata
group by `carrier name` 
order by Total_passengers desc
limit 10;

#Answer 5  Display top Routes ( from-to City) based on Number of Flights 
Select `from - to city`,
count(`# Departures performed`) As Number_of_flights
from maindata
group by `from - to city`
order by Number_of_flights desc
limit 10;


#Answer 6 Identify the how much load factor is occupied on Weekend vs Weekdays.
SELECT 
    CASE 
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`year`, '-', `month_no`, '-', `day`), '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(`# Transported passengers`) AS total_passengers,
    SUM(`# Available seats`) AS total_available_seats,
    ROUND(SUM(`# Transported passengers`) / SUM(`# Available seats`) * 100, 2) AS load_factor_percentage
FROM Maindata
GROUP BY day_type;



#Answer 7 Identify number of flights based on Distance group

SELECT 
    `%Distance Group ID`, 
    count(`# Departures Performed`) AS Total_Flights
FROM 
    maindata
GROUP BY 
    `%Distance Group ID`;


