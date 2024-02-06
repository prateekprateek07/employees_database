use employees_mod;

/* 1.create the visualization that provides the breakdown between the male and females employees
working in the company each year, starting from 1990*/

SELECT YEAR(d.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no

GROUP BY calendar_year , e.gender
HAVING calendar_year >= 1990;


/* 2. compare the number of male managers to the number of female managers from different departments
for each year, starting from 1990*/

select d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calendar_year,
case 
    when year(dm.to_date) >= e.calendar_year and year(dm.from_date) <= e.calendar_year
    then 1  
    else 0
end as active
from (select year(hire_date) as calendar_year from t_employees group by calendar_year)
 e cross join t_dept_manager dm
 join t_departments d on dm.dept_no = d.dept_no
 join t_employees ee on dm.emp_no = ee.emp_no
 order by 3,6;
 
 
 /* 3. Compare the average salary of female versus male employees in the entire company until 
 year 2002, and add a filter allowing you to see that per each department.*/
 
select e.gender, d.dept_name, round(avg(s.salary),2) as salary, year(de.from_date) as calendar_year
from t_salaries s join t_employees e on s.emp_no = e.emp_no
join t_dept_emp de on e.emp_no = de.emp_no
join t_departments d on de.dept_no = d.dept_no
group by 1,2,4
having 4 <= 2002
order by 2;

/*Create an SQL stored procedure that will allow you to obtain the average male and 
female salary per department within a certain salary range. Let this range be defined by 
two values the user can insert when calling the procedure.
Finally, visualize the obtained result-set in Tableau as a double bar chart.*/
    
  drop procedure filter_salary;
  
create procedure filter_salary (in p_min_salary float, in p_max_salary float)
select d.dept_name, e.gender, round(avg(s.salary),2) as salary
from t_employees e join t_salaries s on e.emp_no = s.emp_no
join t_dept_manager dm on s.emp_no = dm.emp_no
join t_departments d on dm.dept_no = d.dept_no
where salary between p_min_salary and p_max_salary
group by 1,2
order by 1;




