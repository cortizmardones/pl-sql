--Guía 2
select * from employees;

--Ejercicio 1
select max(salary) "Salario Máximo",min(salary) "Salario Minimo",
sum(salary) "Sumatoria de los salarios",round(avg(salary)) "Salario Promedio"
from employees;

--Ejercicio 2
select job_id "trabajo",max(salary)"salario maximo",min(salary)"salario minimo",sum(salary)"Suma de salario",round(avg(salary)) "Salario Promedio"
from employees
group by job_id
order by job_id;

--Ejercicio 3
--Forma (A)
select job_id "TRABAJO",count(job_id) "TOTAL EMPLEADOS"
from employees
group by job_id;

--forma (B)
--EN LOS ORDER BY SI FUNCIONAN LOS ALIAS DE ORACLE
select manager_id "Jefe", count(manager_id) "Total de empleados"
from employees
group by manager_id
order by "Total de empleados" desc , "Jefe";

--Forma (C)
select department_id "Departamento", count(employee_id) "Total de empleados por dep.", to_char(sum(salary),'$999G999') "Salario total por dep."
from employees
group by department_id
order by department_id;

--Forma (D)
select to_char((max(salary)-min(salary)),'$999G999') "Diferencia"  
from employees;

--Forma (E)
select count(distinct(nvl(manager_id,0))) "Total de Jefes"
from employees
order by manager_id;

--Forma (F)
--La clasula Having es como el where pero cuando hay un GROUP BY
select department_id "Departamento",count(employee_id) "Total de empleados"
from employees
group by department_id
having count(employee_id) > 5
order by department_id desc;

--Forma (G)
--En esta parte debemos agrupar por los argumentos que tenemos incluidos en el select
select department_id "Departamento" , job_id "Trabajo" , min(salary) "Salario Minimo"
from employees
where department_id is not null
group by department_id , job_id
having min(salary) > 6000
order by department_id , job_id;

--Ejercicio 4
--Lo hice solo y entero rápido <3
--Forma (A)
select department_id "Departamento", count(employee_id) "Total de empleados" , to_char(sum(salary),'$999G999') "Total salario por departamento"
from employees
group by department_id
having sum(salary) between 15000 and 30000
order by "Total salario por departamento";


--Forma (B)
select manager_id "Jefes", count(employee_id) "Empleados a su cargo" , 
max(salary) "Salario Máx. por Dep." , round((count(employee_id)*max(salary))/100) "comision"
from employees
group by manager_id
order by manager_id;

--Forma (C)
select department_id "Departamento",to_char(sum(salary),'$999G999') "Suma de sueldos"  
from employees
group by department_id
order by department_id;

--COPIADO / ME LA GANO
SELECT
  JOB_ID "TRABAJO",
  NVL(TO_CHAR(DECODE(DEPARTMENT_ID,20,SUM(SALARY))),' ') "TOTAL DEPTO 20",
  NVL(TO_CHAR(DECODE(DEPARTMENT_ID,50,SUM(SALARY))),' ') "TOTAL DEPTO 50",
  NVL(TO_CHAR(DECODE(DEPARTMENT_ID,80,SUM(SALARY))),' ') "TOTAL DEPTO 80",
  NVL(TO_CHAR(DECODE(DEPARTMENT_ID,90,SUM(SALARY))),' ') "TOTAL DEPTO 90"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (20,50,80,90)
GROUP BY JOB_ID, DEPARTMENT_ID;
