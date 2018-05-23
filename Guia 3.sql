--Guía 3

select * from COUNTRIES;

--JOIN CON USING--
select employee_id,
department_id,
--Guia 3
select * from employees;
select * from departments;
select * from jobs;

--Ejercicio 1
--Forma (A)
--Utilizando prefijos para identificar las tablas
select 'El empleado '|| e.first_name ||' '|| e.last_name||' trabaja en el departamento de '|| d.department_name "DEPARTAMENTO DEL EMPLEADO"
from employees e join departments d
on (e.department_id = d.department_id);

--Forma (B)
select e.employee_id "EMPLEADO", e.salary "SALARIO", e.job_id "ID_TRABAJO", j.job_title "DESCRIPCION TRABAJO"
from employees e join jobs j
on(e.job_id = j.job_id)
where salary<2700
order by salary;

--Forma (C)
select d.department_name "DEPARTAMENTO", count(e.employee_id) "CANTIDAD DE EMPLEADOS"
from employees e join departments d
on (e.department_id=d.department_id)
group by department_name
order by department_name;

--Forma (D)
--Me costo harto
select d.department_name "Nombre Departamentp", to_char(max(e.salary),'$999G999') "Sueldos máximos"
from departments d join employees e
on (d.department_id = e.department_id)
group by department_name
having max(salary) between 6000 and 20000
order by "Sueldos máximos" desc;

--Forma (E)
select e.first_name ||' '||e.last_name "NOMBRE EMPLEADO" ,
j.job_title "TRABAJO" , 
d.department_name 
from employees e join jobs j
on (e.job_id = j.job_id)
join departments d
on (e.department_id = d.department_id)
join locations l
on(d.location_id = l.location_id)
where city = 'Toronto';

--Forma (F)
--Aquí hay que utilizar un FULL OUTER JOIN
select d.department_id "ID. DEPARTAMENTO",
d.department_name "NOMBRE DEPARTAMENTO",
count(e.employee_id) "TOTAL EMPLEADOS"
from departments d full outer join employees e
on (d.department_id = e.department_id)
group by d.department_id,d.department_name
having count(e.employee_id)=0
order by d.department_id;

--Ejercicio 2
--Ejecutar el script N° 3 que entrego Diglet
select * from empleado;
select * from tipo_empleado;
select * from ventas;
select * from comision_ventas;

--Forma (A)
select 'El empleado '|| e.pnombre ||' '|| e.appaterno ||' se desempeña como '|| tp.desc_tipo_empleado "Personal de la empresa"
from empleado e join tipo_empleado tp
on(e.tipo_empleado=tp.tipo_empleado)
order by appaterno asc;

--Forma (B)
select e.pnombre ||' '||e.appaterno "NOMBRE EMPLEADO",v.nro_boleta "N° BOLETA",v.fecha_boleta "FECHA BOLETA",TO_CHAR(v.monto_total,'$999G999') "MONTO TOTAL"
from empleado e join ventas v
on(e.id_empleado = v.id_empleado)
order by nro_boleta;

--Forma (C)
select e.pnombre ||' '||e.appaterno "NOMBRE EMPLEADO",v.nro_boleta "N° BOLETA",TO_CHAR(v.monto_total,'$999G999') "MONTO TOTAL",
to_char(cv.monto_comision,'$999G999') "COMISION POR VENTA"
from empleado e join ventas v
on(e.id_empleado = v.id_empleado)
join comision_ventas cv
on(v.nro_boleta=cv.nro_boleta)
where TO_CHAR(v.fecha_boleta,'YY')=14
order by e.appaterno,v.monto_total;

--Forma (D)
select e.pnombre||' '|| e.appaterno "NOMBRE EMPLEADO" , 
TO_CHAR(sum(v.monto_total),'$999G999') "TOTAL VENTAS DEL MES",
TO_CHAR(sum(cv.monto_comision),'$999G999') "TOTAL COMISION DEL MES"
from empleado e join ventas v
on (e.id_empleado = v.id_empleado)
join comision_ventas cv
on(v.nro_boleta = cv.nro_boleta)
where to_char(v.fecha_boleta,'MM')=03
group by e.pnombre,e.appaterno
order by sum(cv.monto_comision);

--Forma (E)
select e.pnombre ||' '|| e.appaterno "Nombre Empleado", 
count(v.monto_total) "Monto Total Ventas"
from empleado e full outer join ventas v
on(e.id_empleado = v.id_empleado)
group by e.pnombre,e.appaterno
order by e.appaterno;

--Forma (F)
--En esta me falto imaginación :)
select 'El empleado '|| e.pnombre ||' '|| e.appaterno ||' contratado el '|| to_char(e.fecha_contrato,'DD/MM/YYYY') ||' no ha efectuado ventas a la fecha' "PERSONAL SIN VENTAS"
from empleado e full outer join ventas v
on(e.id_empleado = v.id_empleado)
where v.id_empleado is null;


