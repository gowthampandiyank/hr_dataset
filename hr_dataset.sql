create database hr_dataset;

use hr_dataset;

SELECT * FROM employess_basics;

SELECT * FROM employees_working_details;

SELECT * FROM employee_managers;

--  BASIC SQL ANALYSIS QUESTIONS

-- 1. count of employees

select count(*) as total_employes from employess_basics;

-- 2. count of managers

select count(*) as total_managers from employee_managers;

-- 3. Count the number of employees in each age group

SELECT age_group, COUNT(*)
FROM employess_basics
GROUP BY
age_group;

-- 4 Find the highest and lowest salary

select
max(SALARY) as highest_salary,
min(SALARY) as highest_salary
from employees_working_details;

-- 5 Find the highest and lowest salary position

select
POSITION,
max(SALARY) as highest_salary,
min(SALARY) as highest_salary
from employees_working_details
group by
POSITION;

-- 6 Find the highest and lowest salary depotrment

select
DEPORTMENT,
max(SALARY) as highest_salary,
min(SALARY) as highest_salary
from employees_working_details
group by
DEPORTMENT;

-- 7 Find the highest and lowest salary by ag_group
SELECT
b.age_group,
MAX(w.salary) AS highest_salary,
MIN(w.salary) AS lowest_salary
FROM
employess_basics b
JOIN employees_working_details w ON b.employee_id = w.employee_id
GROUP BY
b.age_group
ORDER BY b.age_group;

-- 8 count by employees_type
SELECT EMPLOYEE_TYPE, COUNT(*)
FROM employees_working_details
GROUP BY
EMPLOYEE_TYPE;

-- 9 Avg working hours by position
SELECT
position,
AVG(working_hours) AS average_working_hours,
COUNT(*) AS employee_count
FROM employees_working_details
GROUP BY
position
ORDER BY employee_count DESC;

-- 10 Salary stats by position
SELECT
position,
COUNT(*) AS employees_count,
AVG(salary) AS average_salary,
MIN(salary) AS minimum_salary,
MAX(salary) AS maximum_salary
FROM employees_working_details
GROUP BY
position;

-- 11 Average salary for Interns per position
SELECT
position,
COUNT(*) AS employee_count,
AVG(salary) AS average_salary
FROM employees_working_details
WHERE
employee_type = 'Intern'
GROUP BY
position
ORDER BY average_salary DESC;

-- 12 Average salary for Part-Time per position

SELECT
position,
employee_type,
AVG(salary) AS average_salary,
COUNT(*) AS employee_count
FROM dbo.employees_working_details
WHERE employee_type = 'Part-Time'
GROUP BY position, employee_type
ORDER BY employee_count DESC;


-- 13 Average salary for Full-Time per position
SELECT
position,
employee_type,
AVG(salary) AS average_salary,
COUNT(*) AS employee_count
FROM employees_working_details
WHERE employee_type = 'Full-Time'
GROUP BY position,employee_type
ORDER BY employee_count DESC;

-- 14 Average salary for Contract per position
SELECT
position,
employee_type,
AVG(salary) AS average_salary,
COUNT(*) AS employee_count
FROM employees_working_details
WHERE
employee_type = 'Contract'
GROUP BY
position,
employee_type
ORDER BY employee_count DESC;

-- 15 Manager-wise summary (counts and salary)
SELECT
m.MANAGER_ID,
m.MANAGER_NAME AS manager_name,
COUNT(*) AS employees_count,
AVG(e.working_hours) AS average_working_hours,
AVG(e.salary) AS avg_salary,
MAX(e.salary) AS max_salary,
MIN(e.salary) AS min_salary
FROM
employees_working_details e
JOIN employee_managers m ON e.MANAGER_id = m.MANAGER_id
GROUP BY
m.MANAGER_id,
m.MANAGER_NAME;

-- 16 Active/inactive per manager
SELECT
m.manager_id,
m.manager_name,
COUNT(e.employee_id) AS total_employees,
SUM(
    CASE
        WHEN e.active_employee = 'ACTIVE' THEN 1
        ELSE 0
    END
) AS active_count,
SUM(
    CASE
        WHEN e.active_employee = 'INACTIVE' THEN 1
        ELSE 0
    END
) AS inactive_count
FROM
employees_working_details e
JOIN employee_managers m ON e.manager_id = m.manager_id
GROUP BY
m.manager_id,
m.manager_name;

-- 17 High-earning interns (above overall avg salary)
SELECT employee_id, name, position, salary
FROM employees_working_details
WHERE
employee_type = 'Intern'
AND salary > (
    SELECT AVG(salary)
    FROM employees_working_details
);

-- 18 Working hour inliers
SELECT
employee_id,
name,
position,
working_hours
FROM employees_working_details
WHERE
working_hours < 9
OR working_hours > 6;

-- 19 Longest working employee per manager
SELECT
e.manager_id,
m.MANAGER_NAME AS manager_name,
e.EMPLOYEE_ID,
e.NAME AS employee_name,
e.WORKING_HOURS
FROM
employees_working_details e
JOIN (
    SELECT manager_id, MAX(WORKING_HOURS) AS max_hours
    FROM employees_working_details
    GROUP BY
        MANAGER_ID
) mh ON e.MANAGER_ID = mh.MANAGER_ID
AND e.WORKING_HOURS = mh.max_hours
JOIN employee_managers m ON e.MANAGER_ID = m.MANAGER_ID;

-- 20 duplicate columns

SELECT salary, COUNT(*) AS duplicate_count
FROM employees_working_details
GROUP BY
salary
HAVING
COUNT(*) > 1;

-- 21 Country-wise employee count
SELECT country, COUNT(*) AS employees_count
FROM employess_basics
GROUP BY
country
ORDER BY COUNTRY DESC;

-- 22 Average salary by employee type
SELECT employee_type, AVG(salary) AS average_salary
FROM employees_working_details
GROUP BY
employee_type;

-- 23 Gender diversity per manager
SELECT
m.MANAGER_ID,
m.MANAGER_NAME AS manager_name,
SUM(
    CASE
        WHEN e.gender = 'Male' THEN 1
        ELSE 0
    END
) AS male_count,
SUM(
    CASE
        WHEN e.gender = 'Female' THEN 1
        ELSE 0
    END
) AS female_count,
SUM(
    CASE
        WHEN e.gender = 'Other' THEN 1
        ELSE 0
    END
) AS other_count,
COUNT(*) AS total_employees
FROM
employess_basics e
JOIN employee_managers m ON e.MANAGER_ID = m.MANAGER_ID
GROUP BY
m.MANAGER_ID,
m.MANAGER_NAME
order by m.MANAGER_ID;

-- 24 Missing or invalid emails (simple rule: missing '@' or '.')
SELECT
employee_id,
name AS employee_name,
email_id
FROM employess_basics
WHERE
email_id NOT LIKE '%@%'
OR email_id NOT LIKE '%.%';

-- 25 Technical writer count per manageR

SELECT m.manager_id, m.manager_name, COUNT(*) AS technical_writer_count
FROM
employees_working_details e
JOIN employee_managers m ON e.manager_id = m.manager_id
WHERE
e.position = 'Technical Writer'
GROUP BY
m.manager_id,
m.manager_name
ORDER BY technical_writer_count DESC;

-- 26 Active vs inactive ratio by employee type
SELECT
employee_type,

SUM(
    CASE
        WHEN active_employee = 'ACTIVE' THEN 1
        ELSE 0
    END
) AS active_count,

SUM(
    CASE
        WHEN active_employee = 'INACTIVE' THEN 1
        ELSE 0
    END
) AS inactive_count,

ROUND(
    SUM(
        CASE
            WHEN active_employee = 'ACTIVE' THEN 1
            ELSE 0
        END
    ) * 1.0
    / NULLIF(
        SUM(
            CASE
                WHEN active_employee = 'INACTIVE' THEN 1
                ELSE 0
            END
        ),
        0
    ),
    2
) AS active_to_inactive_ratio

FROM dbo.employees_working_details
GROUP BY employee_type
ORDER BY employee_type;

-- 27 Unusual mobile numbers (length < 10 digits or non-digit start)
SELECT
employee_id,
name,
mobile_number
FROM dbo.employess_basics
WHERE
mobile_number NOT LIKE '[0-9]%'
OR LEN(mobile_number) < 10;


-- 28 List all employee names and their job positions

SELECT
employee_id,
name AS employee_name,
position
FROM employees_working_details
where
POSITION = 'HR Manager';


-- <30>New SQL Questions (HR Analytics)

-- <1> Employee & Manager Insights

-- 1.1.Find the average salary of employees under each manager.
SELECT m.manager_id, m.MANAGER_NAME AS MANAGER_NAME, AVG(e.salary) AS avg_salary
FROM
employees_working_details e
JOIN employee_managers m ON e.manager_id = m.manager_id
GROUP BY
m.manager_id,
MANAGER_NAME;

-- 1.2. List managers who manage more than 10 employees.

select manager_id, count(*)
from employees_working_details
group by
manager_id
having
count(*) > 10;

-- 1.3. Identify employees who earn more than their manager.

SELECT
e.employee_id,
e.name AS employee_name,
e.salary AS employee_salary,
m.MANAGER_ID,
m.MANAGER_NAME,
mgr.salary AS manager_salary
FROM
employees_working_details e
JOIN employee_managers m ON e.MANAGER_ID = m.MANAGER_ID
JOIN employees_working_details mgr ON m.MANAGER_ID = mgr.EMPLOYEE_ID
WHERE
e.salary > mgr.salary;

-- 1.4 .Count the number of departments each manager oversees (if manager appears in multiple teams).
SELECT
m.manager_id,
m.manager_name,
COUNT(DISTINCT e.deportment) AS department_count,
STRING_AGG(e.deportment, ', ') AS departments
FROM employee_managers m
JOIN (
SELECT DISTINCT manager_id, deportment
FROM employees_working_details
) e
ON m.manager_id = e.manager_id
GROUP BY
m.manager_id,
m.manager_name
ORDER BY department_count DESC;



-- 1.5. Find the total working hours contributed under each manager.

SELECT
m.MANAGER_ID,
m.MANAGER_NAME,
SUM(e.WORKING_HOURS) AS total_working_hours,
count(*) as emloyees_count
FROM
employee_managers m
JOIN employees_working_details e ON m.MANAGER_ID = e.MANAGER_ID
GROUP BY
m.MANAGER_ID,
m.MANAGER_NAME;

-- <2> Salary Analysis

-- 2.1 Find the top 5 highest-paid employees in the company.

SELECT top 5
employee_id,
name AS employee_name,
salary,
POSITION,
deportment
FROM employees_working_details
ORDER BY salary DESC ;

-- 2.2 Identify positions where average salary is below company average.

SELECT POSITION, AVG(salary) AS average_salary
from employees_working_details
GROUP BY
POSITION
HAVING
AVG(salary) < (
    SELECT AVG(salary)
    FROM employees_working_details
);

-- 2.3 List employees whose salary is within 10% of the company’s highest salary.

SELECT
EMPLOYEE_ID,
name AS employee_name,
salary
FROM employees_working_details
WHERE
salary >= 0.9 * (
    SELECT MAX(salary)
    FROM employees_working_details
)
GROUP BY
EMPLOYEE_ID,
name,
salary;

-- 2.4 Find salary variance and standard deviation by department.

SELECT
DEPORTMENT,
VAR(salary) AS salary_variance,
STDEV(salary) AS salary_stddev
FROM employees_working_details
GROUP BY
DEPORTMENT;

-- <3> Employee Performance / Status

-- 3.1 Identify employees who work more than the company average working hours.
select
EMPLOYEE_ID,
NAME AS employee_name,
WORKING_HOURS
FROM employees_working_details
WHERE
WORKING_HOURS > (
    SELECT AVG(WORKING_HOURS)
    FROM employees_working_details
);

-- 3.3 Find employees who joined in the last 90 days.
SELECT
EMPLOYEE_ID,
NAME AS employee_name,
JOINING_DATE
FROM employees_working_details
WHERE
JOINING_DATE >= DATEADD(DAY, -90, CAST(GETDATE() AS DATE));

-- 3.4 Calculate attrition rate per department.
SELECT
deportment,
COUNT(*) AS total_employees,
SUM(
    CASE
        WHEN active_employee = 'INACTIVE' THEN 1
        ELSE 0
    END
) AS exited_employees,
ROUND(
    SUM(
        CASE
            WHEN active_employee = 'INACTIVE' THEN 1
            ELSE 0
        END
    ) * 100.0 / NULLIF(COUNT(*), 0),
    2
) AS attrition_rate_percentage
FROM dbo.employees_working_details
GROUP BY deportment;


-- <4> Data Quality Checks

-- 4.1 Identify duplicate employee records based on name + mobile.
SELECT
name,
mobile_number,
COUNT(*) AS duplicate_count
FROM dbo.employess_basics
GROUP BY name, mobile_number
HAVING COUNT(*) > 1;



-- 4.2 List employees whose joining date is later than exit date (data error).
SELECT *
FROM dbo.employees_working_details
WHERE active_employee = 'INACTIVE'
AND joining_date > GETDATE();



-- 4.3 Find salary values that are NULL or suspicious (0 or negative salary).
SELECT employee_id, salary
FROM dbo.employees_working_details
WHERE salary IS NULL
OR salary <= 0;


-- 4.4 Identify departments with no employees assigned.
SELECT d.deportment
FROM (
SELECT DISTINCT deportment FROM dbo.employees_working_details
) d
LEFT JOIN dbo.employees_working_details e
ON d.deportment = e.deportment
WHERE e.employee_id IS NULL;

-- 4.5 Validate emails that do not end with a corporate domain (e.g., @company.com).
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employess_basics';

-- <5> Age & Demographics

-- 5.1 Find the average age by employee type (Intern, Full-Time, etc.).
SELECT
w.employee_type,
AVG(b.age) AS avg_age
FROM dbo.employess_basics b
JOIN dbo.employees_working_details w
ON b.employee_id = w.employee_id
GROUP BY w.employee_type;

-- 5.2 Count employees who are above 50 years old in each department.
SELECT
w.deportment,
COUNT(*) AS employees_above_50
FROM dbo.employess_basics b
JOIN dbo.employees_working_details w
ON b.employee_id = w.employee_id
WHERE b.age > 50
GROUP BY w.deportment;

-- 5.3 Identify employees whose age is outside normal bounds (age < 18 or > 70).
SELECT employee_id, name, age
FROM dbo.employess_basics
WHERE age < 18 OR age > 70;

-- 5.4 ind gender ratio (male:female) by department.
SELECT
w.deportment,
SUM(CASE WHEN b.gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
SUM(CASE WHEN b.gender = 'Female' THEN 1 ELSE 0 END) AS female_count
FROM dbo.employess_basics b
JOIN dbo.employees_working_details w
ON b.employee_id = w.employee_id
GROUP BY w.deportment;

-- 5.5 List the youngest and oldest employee under each manager.
SELECT
w.manager_id,
MIN(b.age) AS youngest_age,
MAX(b.age) AS oldest_age
FROM dbo.employess_basics b
JOIN dbo.employees_working_details w
ON b.employee_id = w.employee_id
GROUP BY w.manager_id;


-- <6> Advanced SQL Analytics

-- 6.1 Identify positions whose salary is increasing by hierarchy (e.g., Junior < Senior < Lead).
SELECT
position,
AVG(salary) AS avg_salary
FROM dbo.employees_working_details
GROUP BY position
ORDER BY avg_salary;


-- 6.2 Find the distribution of employees by age group and gender.
SELECT
CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 50 THEN '30–50'
    ELSE 'Above 50'
END AS age_group,
gender,
COUNT(*) AS employee_count
FROM dbo.employess_basics
GROUP BY
CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 50 THEN '30–50'
    ELSE 'Above 50'
END,
gender;

-- 6.3 List employees ranked by salary within their department (using window functions).
SELECT
employee_id,
deportment,
salary,
RANK() OVER (
    PARTITION BY deportment
    ORDER BY salary DESC
) AS salary_rank
FROM dbo.employees_working_details;


-- 6.4 Find top 3 performing departments by average working hours.
SELECT TOP 3
deportment,
AVG(working_hours) AS avg_working_hours
FROM dbo.employees_working_details
GROUP BY deportment
ORDER BY avg_working_hours DESC;


-- 6.5 Identify employees with continuous attendance for 30 days (if attendance table exists).
SELECT employee_id,name emply_name,POSITION,DEPORTMENT,SALARY
FROM dbo.employees_working_details
WHERE active_employee = 'ACTIVE'
AND DATEDIFF(DAY, joining_date, GETDATE()) >= 30;


--C:\Users\gowth\OneDrive\Documents\SQL Server Management Studio 22