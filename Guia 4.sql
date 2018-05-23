--Guía 4
select * from employees;

--Ejercicio 1 (Me salío mal hartas veces por que no lei el PPT - Que paja)
--Forma (A) 
select employee_id "Identificación del empleado" , first_name ||' '||last_name "Empleado" , job_id "Job Id",to_char(salary,'$999G999') "Salario"
from employees
where salary = (select salary 
from employees 
where employee_id=204);

--Forma (B) (El calculo es muy paja)
select employee_id "Empleado",to_char(salary,'999G999') "Salario Actual",to_char(hire_date,'DD/MM/YYYY') "Fecha Contrato",
round(SYSDATE-hire_date) "Dias trabajados",
round(((SYSDATE-hire_date)/365)*12) "Meses trabajados",
round((SYSDATE-hire_date)/365) "Años trabajados"
from employees
where salary < (select round(avg(salary)) "Sueldo Promedio Redondeado"
from employees)
order by salary,employee_id;

--Forma (C)
select * from employees;
select * from departments;


select d.department_name "Nombre Departamento", COUNT(e.employee_id) "Cantidad maxima de Empleados"
from departments d join employees e
on(d.department_id = e.department_id)
group by d.department_name
having count(e.department_id) = (select max(COUNT(e.employee_id)) "Cantidad maxima de Empleados"
from departments d join employees e
on(d.department_id = e.department_id)
group by d. department_id);
