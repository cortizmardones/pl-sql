
--Guia 1
select * from employees;

--Ejercicio 1
select first_name ||' '||last_name "EMPLEADO" , NVL(to_char(manager_id),'NO POSEE JEFE') "JEFE"
from employees
order by manager_id desc;

--Ejercicio 2
select employee_id "EMPLEADO", salary "SALARIO" , TRUNC(SALARY/1000) "PORCENTANJE DE MOVILIZACION"
from employees;

--Ejercicio 3
select first_name "NOMBRE", 
last_name "APELLIDO",
job_id "TRABAJO" ,
INITCAP(SUBSTR(first_name,0,3)||LENGTH(first_name)||job_id)"NOMBRE_USUARIO",
TO_CHAR(hire_date,'MMYYYY') || UPPER(SUBSTR(last_name,-2))"CLAVE_USUARIO"
from employees
order by last_name;

--Ejercicio 4
select 
RPAD(first_name,10,' ')||' Posee un salario de '|| LPAD(salary,10,' ')"LISTADO DE SALARIOS"
from employees;

--Ejercicio 5
select 'El empleado '|| first_name ||' '||last_name ||' fue contratado el '|| 
to_char(hire_date,'DAY DD')||' de '||to_char(hire_date,'MONTH') || to_char(hire_date,'YYYY')"CONTRATOS" 
from employees
order by hire_date;

--Ejercicio 6
select 'El empleado ' || first_name ||' posee un sueldo de $'|| TO_CHAR(SALARY,'999G999D00') ||' pero su sueño es ganar '|| TO_CHAR(salary*3,'999G999D00') "Salario Soñado"
from employees;

--Ejercicio 7
select employee_id "EMPLEADO",department_id "DEPARTAMENTO",salary "SALARIO ACTUAL" , ROUND((salary*25.8)/100) "REAJUSTE" , ROUND(((salary*25.8)/100+salary)) "SALARIO REAJUSTADO"
from employees
where salary<5000
order by department_id ,salary desc;

--Ejercicio 8
select first_name ||' '||last_name "Nombre Empleado" , job_id "Trabajo que desempeña",
case job_id when 'AD_PRES' THEN 'A'
when 'ST_MAN' THEN 'B'
when 'IT_PROG' THEN 'C'
when 'SA_REP' THEN 'D'
when 'ST_CLERK' THEN 'E'
ELSE 'O' end "Grado según su trabajo"
from employees
order by last_name;

--Ejercicio 9
select * from employees;
--Rutina (A)
select first_name ||' '||last_name "NOMBRE EMPLEADO" , TO_CHAR(salary,'$999G999') "SALARIO" , TO_CHAR(SALARY*(SUBSTR(SALARY,0,1))/100,'$999G999') "REAJUSTE"
from employees;

--Rutina (B)
select employee_id "ID EMPLEADO",salary "SALARIO SIN COMISION",
NVL(commission_pct,0) "PORC. COMISION",NVL(salary*commission_pct,0) "VALOR COMISION",NVL(salary+(commission_pct*salary),salary) "SALARIO TOTAL"
from employees;

--Rutina (C)
select employee_id,hire_date,salary,to_char(SYSDATE,'yyyy')-to_char(hire_date,'YYYY') "ANOS_CONTRATADOS",
(SALARY * (to_char(SYSDATE,'yyyy')-to_char(hire_date,'YYYY')))/100 "AUMENTO"
from employees
where salary between 1000 and 5000;








