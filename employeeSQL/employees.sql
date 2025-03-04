CREATE DATABASE sql_challenge;

USE sql_challenge;  -- Ensure to use the database

CREATE TABLE title (
    title_id VARCHAR(20) PRIMARY KEY NOT NULL,
    title VARCHAR(20)
);

CREATE TABLE employees (
    emp_no INT PRIMARY KEY NOT NULL,
    emp_title_id VARCHAR(20) NOT NULL,
    birth_date DATE,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    sex CHAR(1),  -- Specify length for CHAR
    hire_date DATE,
    FOREIGN KEY (emp_title_id) REFERENCES title(title_id) 
);

CREATE TABLE departments (
    dept_no VARCHAR(20) PRIMARY KEY NOT NULL,
    dept_name VARCHAR(20)
);

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)  
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(20) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),  -- Composite primary key
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no), 
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no) 
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(20),
    emp_no INT NOT NULL,
    PRIMARY KEY (dept_no, emp_no),  -- Composite primary key
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),  
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no) 
);

ALTER TABLE employees 
ADD CONSTRAINT fk_employees_emp_title_id 
FOREIGN KEY (emp_title_id) 
REFERENCES title (title_id);

ALTER TABLE dept_emp 
ADD CONSTRAINT fk_dept_emp_emp_no 
FOREIGN KEY (emp_no) 
REFERENCES employees (emp_no);

ALTER TABLE dept_emp 
ADD CONSTRAINT fk_dept_emp_dept_no 
FOREIGN KEY (dept_no) 
REFERENCES departments (dept_no);

ALTER TABLE dept_manager 
ADD CONSTRAINT fk_dept_manager_emp_no 
FOREIGN KEY (emp_no) 
REFERENCES employees (emp_no);

ALTER TABLE dept_manager 
ADD CONSTRAINT fk_dept_manager_dept_no 
FOREIGN KEY (dept_no) 
REFERENCES departments (dept_no);

ALTER TABLE salaries 
ADD CONSTRAINT fk_salaries_emp_no 
FOREIGN KEY (emp_no) 
REFERENCES employees (emp_no);


--import all csv files via tables import menu

--ANALYSIS
--#1 Find the emp #, name, sex, and salary of everyone

SELECT * FROM employees;
SELECT * FROM salaries;

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
LEFT JOIN salaries AS s
ON e.emp_no = s.emp_no;

--#2 Find the employees that were hired in 1986

SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--#3 Show the managers for each department and their employee #

SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM departments;

SELECT e.last_name, e.first_name, m.dept_no, m.emp_no, d.dept_name 
FROM dept_manager m
RIGHT JOIN departments d ON d.dept_no = m.dept_no
INNER JOIN employees e ON e.emp_no = m.emp_no;

--#4 List the department of each employee with their #, name, and dept name.

SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM departments;

SELECT m.emp_no, e.last_name, e.first_name, d.dept_name, m.dept_no   
FROM dept_emp m
RIGHT JOIN departments d ON d.dept_no = m.dept_no
INNER JOIN employees e ON e.emp_no = m.emp_no;

--#5 Find the employees named "Hercules" that also have a last name starting with B

SELECT e.first_name, e.last_name, e.sex
FROM employees AS e
WHERE e.first_name='Hercules' AND e.last_name LIKE 'B%';

--#6 Display only the employees in the sales departments.

SELECT * FROM dept_emp;
SELECT * FROM employees;
SELECT * FROM departments;

SELECT d.dept_name, e.first_name, e.last_name, e.emp_no
FROM dept_emp m
INNER JOIN employees e ON e.emp_no = m.emp_no
INNER JOIN departments d ON d.dept_no = m.dept_no 
WHERE d.dept_name IN (
    SELECT dept_name
    FROM departments
    WHERE dept_name = 'Sales');

--#7 Display only the employees in the sales and dev departments.

SELECT * FROM dept_emp;
SELECT * FROM employees;
SELECT * FROM departments;

SELECT d.dept_name, e.first_name, e.last_name, e.emp_no
FROM dept_emp m
INNER JOIN employees e ON e.emp_no = m.emp_no
INNER JOIN departments d ON d.dept_no = m.dept_no 
WHERE d.dept_name IN (
    SELECT dept_name
    FROM departments
    WHERE dept_name = 'Sales' OR dept_name = 'Development');

--#8 Count the unique last names 
--insert a column that will store the count of each last name, descending order.

SELECT e.last_name, COUNT(*) AS count_result
FROM employees AS e
GROUP BY e.last_name
ORDER BY count_result DESC;

--done
