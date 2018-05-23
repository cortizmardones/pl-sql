--Experiencia 7 (Inntroduccion a PL-SQL)
SET SERVEROUTPUT ON;
DECLARE
v_fname VARCHAR(20);
BEGIN
  SELECT FIRST_NAME
  INTO v_fname
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = 100;
  DBMS_OUTPUT.PUT_LINE('El primer nombre del empleado 100 es : ' || v_fname);
END;

--Experiencia 7.2 (Variables)
DECLARE
  v_comm  	NUMBER(3) DEFAULT 200;
  c_comm	CONSTANT NUMBER(4) := 1400; 
BEGIN
   DBMS_OUTPUT.PUT_LINE('Valor inicial de variable v_comm es : ' || v_comm);
   DBMS_OUTPUT.PUT_LINE('Valor inicial de variable c_comm es : ' || c_comm);
/* A la variable v_comm se le modifica el valor asignado inicialmente (200) por el valor 50 */
   v_comm := 50;
   DBMS_OUTPUT.PUT_LINE('Nuevo valor de variable v_comm es : ' || v_comm);
END;

--Ejemplo de variables tipo TYPE

declare
v_emp_apellido employees.last_name%TYPE;
v_balance            NUMBER(7,2);
v_min_balance    v_balance%TYPE := 1000;
begin
end;














--Experiencia 8 (Funcionas,Operadores,etc)
DECLARE
  v_apell	       employees.last_name%TYPE;
  v_nombre       employees.first_name%TYPE;
  v_comision     employees.commission_pct%TYPE;
BEGIN
--NVL verifica si hay nulos en el campo commission_pct y los cambia por 0
     SELECT last_name, UPPER(first_name), NVL(commission_pct,0)
          INTO v_apell, v_nombre, v_comision
        FROM employees
      WHERE employee_id = 110;
     DBMS_OUTPUT.PUT_LINE('Apellido empleado 110: ' || v_apell);
     DBMS_OUTPUT.PUT_LINE('Largo apellido empleado 110: ' || LENGTH(v_apell));  
     DBMS_OUTPUT.PUT_LINE('Nombre empleado 110 en mayúscula: ' || v_nombre);
     DBMS_OUTPUT.PUT_LINE('Porcentaje_comisión empleado 110: ' || v_comision);  
END;
--(Insertar secuencias en PL-SQL)
DECLARE
  v_nuevo_id   NUMBER(6);
BEGIN
  v_nuevo_id := nombre_secuencia.NEXTVAL;
END;

--Bloques PL-SQL Anidados + ambito y visibilidad de una variable.
<<padre>>
DECLARE
 nombre_padre     VARCHAR2(20):='Patricio';
 fecha_de_cumple DATE:='20-Abr-1972';
BEGIN
   DECLARE
   nombre_hijo     VARCHAR2(20):='Miguel';
   fecha_de_cumple DATE:='13-May-1992';
   BEGIN 
      DBMS_OUTPUT.PUT_LINE('Nombre del padre:' || ' ' || nombre_padre);
      DBMS_OUTPUT.PUT_LINE('Dia de Cumpleaño: '|| padre.fecha_de_cumple);
      DBMS_OUTPUT.PUT_LINE('Nombre del hijo :' || ' ' || nombre_hijo);
      DBMS_OUTPUT.PUT_LINE('Dia de Cumpleaño: '|| fecha_de_cumple);
   END;
END;

--Buenas practicas (Mayuscula-Minusculas) , identación , conversiones , etc.
DECLARE
  v_id_emp                 employees.employee_id%TYPE;
  v_fecha_contrato    VARCHAR2(20);
  v_salario                  NUMBER(6):=6000; 
BEGIN 
    SELECT employee_id, TO_CHAR(hire_date,'Month DD, YYYY'), salary
    INTO v_id_emp, v_fecha_contrato, v_salario
    FROM employees
    WHERE  employee_id = 200;
    DBMS_OUTPUT.PUT_LINE('El empleado ' || v_id_emp || ' se contrató en ' ||
                    v_fecha_contrato || ' . Su salario mensual  es de $ ' || v_salario);
END;


















--Experiencia 9 (Retornar un dato para cada variable) Error 01422
DECLARE
 v_contrato   employees.hire_date%TYPE;
 v_salario    employees.salary%TYPE;  
BEGIN
   SELECT   hire_date, salary
        INTO   v_contrato, v_salario
      FROM   employees
   WHERE   employee_id = 100;  
  DBMS_OUTPUT.PUT_LINE('La fecha de contrato del empleado 100 es: ' || v_contrato);
  DBMS_OUTPUT.PUT_LINE('El salario del empleado 100 es: ' || v_salario);
END;

--Ejemplo de inserciones en BDD. (Ejemplo 1)

BEGIN
    INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, 
                                              job_id, salary)
     VALUES(employees_seq.NEXTVAL, 'Ruth', 'Cores','RCORES', sysdate, 
                    'AD_ASST', 4000);
END;

--Ejemplo de inserciones en BDD + inserción de tablas. (Ejemplo 2)
CREATE TABLE bono
(id_empleado NUMBER(6),
 bono NUMBER(8,2));
 
 BEGIN
    INSERT INTO bono
    (SELECT employee_id, ROUND(salary * 0.20)
        FROM employees);
END;

--UPDATE
DECLARE					
  v_sal_incrementado   employees.salary%TYPE := 800;   
BEGIN
  UPDATE employees
         SET salary = salary + v_sal_incrementado
   WHERE job_id = 'ST_CLERK';
END;

--DELETE
DECLARE
  v_depto   employees.department_id%TYPE := 10; 
BEGIN							
  DELETE FROM   employees
   WHERE department_id = v_depto;
END;

--Commit , Rollback , SavePoint (PPT Experiencia 09)
















--Experiencia 10 (Ciclos)
--Sentencia IF Simple
DECLARE
  v_mi_edad       number(2) := 10;
  v_mi_nombre   varchar2(20) := 'Luis';
BEGIN
  IF v_mi_edad < 11  AND  v_mi_nombre = 'Luis' THEN
     DBMS_OUTPUT.PUT_LINE('Yo soy un niño que se llama Luis');
  END IF;
END;

--Sentencia IF anidada.
DECLARE
v_mi_edad  number(2) :=31;
BEGIN
   IF v_mi_edad  < 20  THEN
        DBMS_OUTPUT.PUT_LINE('Yo soy un niño');
   ELSIF v_mi_edad < 30 THEN
       DBMS_OUTPUT.PUT_LINE('Yo estoy en mis veintes');
   ELSIF v_mi_edad < 40 THEN
       DBMS_OUTPUT.PUT_LINE('Yo estoy en mis treintas');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Yo siempre seré joven');
   END IF;
END;

--Sentencia if anidadad comparandola con algun valor de alguna tabla
DECLARE
v_sal_max  NUMBER(5);
BEGIN
   SELECT MAX(salary) INTO v_sal_max
      FROM employees;
   IF v_sal_max  < 5000  THEN
        DBMS_OUTPUT.PUT_LINE('Salario máximo menor a 5000');
   ELSIF v_sal_max < 10000  THEN 
       DBMS_OUTPUT.PUT_LINE('Salario máximo menor a 10000 y mayor = a 5000');
   ELSIF v_sal_max < 15000 THEN
       DBMS_OUTPUT.PUT_LINE('Salario máximo menor a 15000 y mayor = a 10000');
   ELSIF v_sal_max < 20000 THEN
       DBMS_OUTPUT.PUT_LINE('Salario máximo menor a 20000 y mayor = a 15000');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Salario máximo es mayor a 20000');
   END IF;
END;

--Ejemplo uso de Case
DECLARE
v_calidad         varchar2(1) := 'A';
v_valoracion  varchar2(20);
BEGIN
   v_valoracion := 
      CASE v_calidad
         WHEN 'A' THEN ' Excelente'
         WHEN 'B' THEN ' Muy bueno'
         WHEN 'C' THEN ' Bueno'
         ELSE 'No existe calidad'
      END;
DBMS_OUTPUT.PUT_LINE ('Calidad: '|| v_calidad || ' Valoración:' || v_valoracion);
END;

--When mas complicado.
DECLARE
 v_sal_prom    NUMBER(5);   
BEGIN
  SELECT ROUND(AVG(salary))
  INTO v_sal_prom
  FROM employees;
  CASE 
      WHEN  v_sal_prom < 5000 THEN
         UPDATE employees
                 SET salary = salary * 1.25
           WHERE salary < v_sal_prom;
      WHEN v_sal_prom < 7000 THEN
          UPDATE employees
                 SET salary = salary * 1.10
           WHERE salary < v_sal_prom;
      ELSE
           DBMS_OUTPUT.PUT_LINE('No corresponde aumento de salario');
  END CASE;
END;

-- Esructura FOR FOR  FOR  FOR
DECLARE
  v_countryid   locations.country_id%TYPE := 'CA';
  v_loc_id          locations.location_id%TYPE;
  v_new_city     locations.city%TYPE := 'Montreal';
BEGIN
  SELECT MAX(location_id) 
       INTO v_loc_id 
     FROM locations
   WHERE country_id = v_countryid;
   FOR i IN 1..3 LOOP
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((v_loc_id + i), v_new_city, v_countryid );
   END LOOP;
END;
-- Esructura FOR FOR  FOR  FOR (2)
DECLARE
  v_countryid   locations.country_id%TYPE := 'CA';
  v_loc_id          locations.location_id%TYPE;
  v_new_city     locations.city%TYPE := 'Montreal';
  v_limite_inf    NUMBER(1):=1;
  v_limite_sup  NUMBER(1):=3;
BEGIN
  SELECT MAX(location_id) 
       INTO v_loc_id 
     FROM locations
   WHERE country_id = v_countryid;
   FOR i IN v_limite_inf .. v_limite_sup LOOP
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((v_loc_id + i), v_new_city, v_countryid );
   END LOOP;
END;



















--Experiencia 11 (CURSORES)
--(Estructura de cursores)
/*Crea el cursor*/                                  CURSOR nombre_cursor IS
/*Construyo la consulta SQL*/                       sentencia_select;
/*Abro el cursor*/                                  OPEN nombre_cursor;
/*Fectch recupera la fila y avanza al siguiente*/   FETCH nombre_cursor INTO lista_de_variables;
/*Cierra el cursor*/                                Close cursor;

--Sintaxis completa de un cursor.
DECLARE
CURSOR cur_emp IS

   SELECT employee_id, last_name 
       FROM employees
    WHERE department_id =30;
    
lname   employees.last_name%TYPE;
empno   employees.employee_id%TYPE;
BEGIN
   OPEN cur_emp;
   FETCH cur_emp INTO empno, lname;
   DBMS_OUTPUT.PUT_LINE(empno || '   ' || lname);    
   CLOSE cur_emp;
END;

--Sintaxis de cursosr con ciclo integrado (Loop Basico)
DECLARE
  CURSOR c_emp_cursor IS 
   SELECT employee_id, last_name FROM employees
   WHERE department_id =30;
  v_empno employees.employee_id%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  OPEN c_emp_cursor;
  LOOP
    FETCH c_emp_cursor INTO v_empno, v_lname;
    EXIT WHEN c_emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( v_empno ||'  '||v_lname);  
  END LOOP;
END;

--Sintaxis de cursor con ciclo integrado (FOR INTEGRADO).
DECLARE
  CURSOR cur_emp IS 
   SELECT employee_id, last_name 
       FROM employees
    WHERE department_id =30; 
BEGIN
   FOR reg_emp IN cur_emp LOOP
       DBMS_OUTPUT.PUT_LINE( reg_emp.employee_id || ' ' || reg_emp.last_name);   
   END LOOP; 
END;

--Cursores con parametros.
DECLARE
 CURSOR   emp_cursor (p_deptno NUMBER) IS
       SELECT  employee_id, last_name
          FROM  employees
       WHERE   department_id = p_deptno;
v_empno      employees.employee_id%TYPE;
v_lname      employees.last_name%TYPE;
BEGIN
   OPEN emp_cursor (30);
   DBMS_OUTPUT.PUT_LINE('Empleados Depto 30');
      LOOP
          FETCH emp_cursor INTO v_empno, v_lname;
          EXIT WHEN emp_cursor%NOTFOUND; 
          DBMS_OUTPUT.PUT_LINE('   ' || rpad(v_empno, 19, ' ') ||' '||v_lname);
      END LOOP;
   CLOSE emp_cursor;
   OPEN emp_cursor (20);
   DBMS_OUTPUT.NEW_LINE();     
   DBMS_OUTPUT.PUT_LINE('Empleados Depto 20');
       LOOP
           FETCH emp_cursor INTO v_empno, v_lname;
           EXIT WHEN emp_cursor%NOTFOUND; 
           DBMS_OUTPUT.PUT_LINE('   ' || rpad(v_empno, 19, ' ') ||' '|| v_lname);
       END LOOP;
   CLOSE emp_cursor;
END;

--Cursor con subconsultas
DECLARE
CURSOR mi_cursor IS
   SELECT first_name || ' ' || last_name, salary
    FROM employees
    WHERE salary < (SELECT ROUND(AVG(salary))
                                    FROM employees)
    ORDER BY salary, last_name;
nombre   VARCHAR2(50);
salario   employees.salary%TYPE;
BEGIN
   OPEN mi_cursor;
   DBMS_OUTPUT.PUT_LINE('    FUNCIONARIOS CON SALARIO MENOR AL PROMEDIO  ');
   DBMS_OUTPUT.PUT_LINE('    ----------------------------------------  ');
   LOOP
       FETCH mi_cursor INTO nombre, salario;
       EXIT WHEN mi_cursor%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE(rpad(nombre, 25, ' ' ) || ' : ' || TO_CHAR(salario, '$999,999'));
     END LOOP;
  CLOSE mi_cursor;
END;



--Trabajando con mas de un cursor.
DECLARE
 CURSOR cur_deptos IS
   SELECT department_id, department_name
     FROM departments;     
 CURSOR cur_emp_depto(deptno NUMBER) IS
   SELECT first_name || ' ' || last_name nombre_emp
     FROM employees
    WHERE department_id = deptno;
v_total_emp  NUMBER(2);
BEGIN
  DBMS_OUTPUT.PUT_LINE('    Empleados por Departamento');
  DBMS_OUTPUT.PUT_LINE('===================================');
  DBMS_OUTPUT.NEW_LINE();
  FOR reg_deptos IN cur_deptos LOOP
      DBMS_OUTPUT.PUT_LINE('Departamento: '|| reg_deptos.department_name);     
      DBMS_OUTPUT.PUT_LINE('====================================='); 
      v_total_emp := 0;     
          FOR reg_emp_depto IN cur_emp_depto(reg_deptos.department_id) LOOP
                   DBMS_OUTPUT.PUT_LINE(reg_emp_depto.nombre_emp);
                   v_total_emp := v_total_emp + 1;
          END LOOP;
          DBMS_OUTPUT.PUT_LINE('=====================================');
          DBMS_OUTPUT.PUT_LINE('Total de Empleados: ' || v_total_emp);
          DBMS_OUTPUT.NEW_LINE();
  END LOOP; 
END;





















--Experiencia 12 (Excepciones)
--Ejemplo de cuando la consulta rtetorna mas de un valor
DECLARE
  lname VARCHAR2(15);
BEGIN
  SELECT last_name INTO lname 
      FROM employees 
   WHERE first_name='John'; 
   DBMS_OUTPUT.PUT_LINE ('John''s last name is : ' ||lname);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
  DBMS_OUTPUT.PUT_LINE ('La sentencia SELECT recupera múltiples filas. Considere usar un Cursor Explícito.');
END;

--Excepcion cuando la consulta recupera más de una fila y cuando no hay resultados.
DECLARE
 v_lname VARCHAR2(15);
BEGIN
  SELECT last_name 
       INTO v_lname 
      FROM employees 
   WHERE first_name = 'Juanito'; 
   DBMS_OUTPUT.PUT_LINE ('John''s last name is : ' || v_lname);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE ('La sentencia SELECT recupera múltiples filas');
  WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE ('La sentencia SELECT no recupera fila');
END;

--Insertando datos en tablas con las excepciones
CREATE SEQUENCE seq_errores;
CREATE TABLE errores
(correlativo           NUMBER(10) CONSTRAINT PK_ERRORES PRIMARY KEY,
 nombre_proceso  VARCHAR2(80),
 mensaje_error      VARCHAR2(255));

BEGIN
  INSERT INTO departments(department_id, department_name, manager_id, location_id)
      VALUES(10, 'Depto Nuevo', 200, 1700);
EXCEPTION
  WHEN DUP_VAL_ON_INDEX  THEN
     INSERT INTO errores 
     VALUES(seq_errores.NEXTVAL, 'Bloque PL/SQL Inserta Departamento',
                    'Insertando un valor de Clave Primaria que ya existe');
     COMMIT;
END;

--Listado de posibles excepciones.
/*
  ACCESS_INTO_NULL (ORA-06530) : Se ha intentado asignar valores a los atributos de un  objeto que no se ha inicializado.
  CASE_NOT_FOUND (ORA-06592) : Ninguna de las opciones en la cláusula WHEN de una sentencia CASE se ha seleccionado y no se ha definido la cláusula ELSE.
  COLLECTION_IS_NULL (ORA-06531) : Se intentó asignar valores a una tabla anidad o varray aún no inicializada.
  CURSOR_ALREADY_OPEN  (ORA-06511) : Se intentó abrir un cursor que ya se encuentra abierto.
  DUP_VAL_ON_INDEX (ORA-00001) :Se intentó ingresar un valor duplicado en una columna(s) definida(s) como Clave Primaria o Unique en la tabla.
  INVALID_CURSOR (ORA-01001) : Se ha intentado efectuar una operación no válida sobre un cursor.
  INVALID_NUMBER (ORA-01722) : La conversión de una cadena de caracteres a número ha fallado cuando esa cadena no representa un número válido.
  LOGIN_DENIED (ORA-01017) : Se ha conectado al servidor Oracle con un nombre de usuario o password inválido.
  NO_DATA_FOUND (ORA-01403) : Una sentencia SELECT no retornó valores o se ha referenciado a un elemento no inicializado en una tabla indexada.
  NOT_LOGGED_ON (ORA-01012) : El programa PL/SQL efectuó una llamada a la Base de Datos sin estar conectado al servidor Oracle
  PROGRAM_ERROR  (ORA-06501) : PL/SQL tiene un problema interno.
  STORAGE_ERROR  (ORA-06500) : PL/SQL se quedó sin memoria o la memoria está corrupta.
  SUBSCRIPT_BEYOND_COUNT  (ORA-06533) : Se ha referenciado un elemento de una tabla anidad o índice de varray mayor que el número de elementos de la colección.
  SUBSCRIPT_OUTSIDE_LIMIT  (ORA-06532) : Se ha referenciado un elemento de una tabla anidada o índice de varray fuera del rango (Ej. -1).
  SYS_INVALID_ROWID  (ORA-01410) : Fallo al convertir una cadena de caracteres a un tipo ROWID.
  TIMEOUT_ON_RESOURCE  (ORA-00051) : Se excedió el tiempo máximo de espera por un recurso de Oracle.
  TOO_MANY_ROWS (ORA-01422) : Una sentencia SELECT INTO retorna más de una fila.
  VALUE_ERROR  (ORA-06502) : Ocurrió un error aritmético, de conversión o truncamiento. Por ejemplo cuando se intenta almacenar un valor muy grande en una variable más pequeña.
  ZERO_DIVIDE  (ORA-01476) : El programa intentó hacer una división por cero.
*/

--Controlar las wexcepciones en más de 2 bloques begind-end.
DECLARE
nombre   employees.first_name%type;
registro countries%ROWTYPE;
BEGIN
    SELECT first_name INTO nombre
       FROM employees
     WHERE employee_id = 100;
            BEGIN
                    SELECT * INTO registro
                        FROM countries
                     WHERE country_id='ZZ';
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No hay fila en countries');
            END;
EXCEPTION
WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('No hay fila en employees');
END;

