--Experiencia 13 Procedimientos de almacenado

CREATE TABLE dept AS SELECT * FROM DEPARTMENTS;

--Pruebas para verificar los datos.
select * from  departments
where department_id = 200;
select * from dept;
TRUNCATE TABLE DEPT;

--Creacion de un store procedure.
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE  SP_ADD_DEPT  IS
 dept_id       dept.department_id%TYPE;
 dept_name dept.department_name%TYPE;
BEGIN
   dept_id:=280;
   dept_name:='ST-Curriculum';
   INSERT INTO dept(department_id,department_name) 	VALUES(dept_id,dept_name);
 DBMS_OUTPUT.PUT_LINE(' Filas insertadas: '||SQL%ROWCOUNT);
END;

--Ejecutando un procedimiento de almacenado
EXEC SP_ADD_DEPT;

--Ejecutando el procedimiento de almacenado dentro de un bloque begind-end
BEGIN
   SP_ADD_DEPT;
END;


--Procedimientos de almacenado con parametros de entrada (IN)
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE sp_aumenta_salario (p_id   NUMBER, p_sal  NUMBER) 
IS
BEGIN
   UPDATE employees
           SET salary = p_sal
    WHERE employee_id = p_id;
END sp_aumenta_salario;

--LLamando al procedimiento.
exec sp_aumenta_salario(100,777777);

--Verificando resultados.
select * from employees;



--Utilizando parametros IN y OUT
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE sp_selecciona_emp
 (p_id      IN    employees.employee_id%TYPE,
  p_nombre  OUT   employees.last_name%TYPE,
  p_salario OUT   employees.salary%TYPE)  
IS
BEGIN
  SELECT  last_name, salary INTO p_nombre, p_salario
     FROM   employees
   WHERE  employee_id = p_id;
END sp_selecciona_emp;

--Utilizando ambos parametros. IN Y OUT en un bloque BEGIN-END.
DECLARE
  v_nombre   employees.last_name%TYPE;
  v_salario    employees.salary%TYPE;
BEGIN
  sp_selecciona_emp(171, v_nombre, v_salario); 
  DBMS_OUTPUT.PUT_LINE('El nombre y salario del empleado 171 son : ' || v_nombre || ' ' || v_salario);
END;


--Utilizando procedimientos de almacenado con parametros IN OUT
CREATE OR REPLACE PROCEDURE sp_formato_telefono
(p_num_telefono IN OUT VARCHAR2) 
IS
BEGIN
  p_num_telefono := '(' || SUBSTR(p_num_telefono,1,3) ||
              ')' || SUBSTR(p_num_telefono,4,3) ||
              '-' || SUBSTR(p_num_telefono,7);
END sp_formato_telefono;
--Utilizando ambos parametros. IN OUT en un bloque BEGIN-END.
DECLARE
  v_num_telefono   VARCHAR2(15):='8006330575';
 BEGIN
  dbms_output.put_line('Valor entrada al procedimiento : ' ||v_num_telefono); 
  sp_formato_telefono(v_num_telefono); 
  dbms_output.put_line('Valor que retorna el procedimiento: ' ||v_num_telefono);
END;

--Procedimientos de almacenado dentro de otro.
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE sp_aumentar_salario
 (id             IN employees.employee_id%TYPE,
  porcent   NUMBER)
IS
BEGIN
  UPDATE employees
          SET    salary = salary * (1 + porcent/100)
    WHERE  employee_id = id;
END sp_aumentar_salario;

CREATE OR REPLACE PROCEDURE sp_procesa_empleados  IS
   CURSOR emp_cursor IS
     SELECT employee_id
        FROM  employees
   WHERE department_id = 50;
BEGIN
   FOR emp_rec IN emp_cursor 
   LOOP
       sp_aumentar_salario(emp_rec.employee_id, 10);
END LOOP;    
   COMMIT;
END;


--Procedimientos con excepcion.
CREATE OR REPLACE PROCEDURE  sp_add_department
(p_cod  NUMBER, p_name VARCHAR2, p_mgr NUMBER, p_loc NUMBER) IS
BEGIN
  INSERT INTO DEPARTMENTS (department_id,  department_name, 
                                                     manager_id, location_id)
   VALUES (p_cod, p_name, p_mgr, p_loc);
  DBMS_OUTPUT.PUT_LINE('Departamento agregado: '||p_name);
EXCEPTION
 WHEN DUP_VAL_ON_INDEX  THEN
  DBMS_OUTPUT.PUT_LINE('Error: código de departamento ya existe: '||p_cod);
END;

--Resultado del procedimiento.
CREATE OR REPLACE PROCEDURE  sp_create_department  IS
BEGIN
  sp_add_department(555,'Media', 100, 1800);
  sp_add_department(120, 'Editing', 99, 1800);
  sp_add_department(999, 'Advertising', 101, 1800);
END;

--Eliminar un procedimiento de almacenado.
DROP PROCEDURE nombre_procedimiento ;






























--Experiencia 14 (Funciones)

--Sintaxis de una función.
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION FN_OBT_SALARIO
 (id   employees.employee_id%TYPE) RETURN NUMBER IS
  sal employees.salary%TYPE := 0;
BEGIN
    SELECT salary INTO sal
    FROM employees         
    WHERE employee_id = id;
  RETURN sal;
END FN_OBT_SALARIO;

--Utilizando la funciónm dentro de un bloque PL-SQL;
SELECT employee_id, FN_OBT_SALARIO(employee_id) SALARIO
FROM employees
WHERE department_id = 30;


--Ejemplo de función 2
DECLARE 
v_sal     employees.salary%type;
v_emp  NUMBER(3):=100;
BEGIN
  v_sal := FN_OBT_SALARIO(v_emp); 
  DBMS_OUTPUT.PUT_LINE('El salario del empleado ' || v_emp || ' es ' ||          	                                                 	                            TO_CHAR(v_sal,'$999,999'));
END;

--Utilizando la función como parametro de otro pograma.
BEGIN 
  dbms_output.put_line(FN_OBT_SALARIO(100)); 
END;


--Usando la función en otro subprograma 
SET SERVEROUTPUT ON; 
CREATE OR REPLACE PROCEDURE sp_salarios_por_depto
(p_depto NUMBER)  IS
   CURSOR emp_cursor IS
     SELECT employee_id
        FROM  employees
   WHERE department_id = p_depto;
v_salario NUMBER(5):=0;
BEGIN
   dbms_output.put_line(' Salarios Departamento ' || p_depto);
   dbms_output.put_line('------------------------------------------------------- ' );
   dbms_output.new_line();
   dbms_output.put_line('Id. Empleado             Salario ' );
   dbms_output.put_line('------------------------------------------------' );
   FOR emp_rec IN emp_cursor 
   LOOP
       v_salario := FN_OBT_SALARIO(emp_rec.employee_id);
       dbms_output.put_line(RPAD(emp_rec.employee_id, 30, ' ')  || v_salario);
   END LOOP;    
END;

--Ejecutando la función.
EXEC sp_salarios_por_depto(20);



--VERDADERA UTILIDAD DE LAS FUNCIONES (REEMPLAZAN A LOS VALORES DE UN SELECT)
CREATE OR REPLACE FUNCTION FN_IMPUESTO(p_valor  IN NUMBER)
 RETURN NUMBER IS
BEGIN
   RETURN (p_valor * 0.08);
END FN_IMPUESTO;

--(LLAMANDO LA FUNCIÓN DENTRO DE UN SELECT.)
SELECT employee_id, last_name, salary, FN_IMPUESTO(salary)
FROM   employees
WHERE  department_id = 100;


--verdadera naturaleza de las funciones. subconsultas
SELECT employee_id, FN_IMPUESTO(salary)
FROM employees			                    
WHERE FN_IMPUESTO(salary) >  (SELECT MAX(FN_IMPUESTO(salary))
                              FROM employees
                              WHERE department_id = 30)
ORDER BY FN_IMPUESTO(salary) DESC;


--Restricciones definidas por el usuario.
CREATE OR REPLACE FUNCTION FN_DML_SQL(sal NUMBER)
   RETURN NUMBER IS
BEGIN
  INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, salary)
  VALUES(1, 'Frost', 'jfrost@company.com', SYSDATE, 'SA_MAN', sal);
  RETURN (sal + 100);
END;

--Llamando a la mierda de arriba.
SELECT FN_DML_SQL(salary) FROM employees;

--Eliminar una fucnión.
DROP FUNCTION fn_obtiene_sal;








































--Experiencia 15 (Package)

--Sintaxis de la declaración de un package.
SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE PKG_COMM IS
   v_comm_ok    VARCHAR2(2);
   PROCEDURE SP_RESET_COMM(p_nueva_comm NUMBER);
END PKG_COMM;

--Package utilizando funciones
CREATE OR REPLACE PACKAGE PKG_DATOS_EMP IS
 v_nombre_depto    VARCHAR2(50);
  FUNCTION FN_OBT_DEPTO(p_cod_depto NUMBER) RETURN VARCHAR2;
END PKG_DATOS_EMP;


--Ejemplo 1 de cuerpo de package
CREATE OR REPLACE PACKAGE BODY PKG_COMM IS 
   FUNCTION FN_VALIDA(comm NUMBER) RETURN VARCHAR2 IS
   v_max_comm    employees.commission_pct%type;
   BEGIN
      SELECT MAX(commission_pct) INTO v_max_comm
      FROM   employees;
      IF COMM > V_MAX_COMM THEN
           RETURN 'NO';
      ELSE
          RETURN 'OK';
      END IF;
   END FN_VALIDA;
   PROCEDURE SP_RESET_COMM(p_nueva_comm NUMBER) IS 
   BEGIN
           v_comm_ok := FN_VALIDA(p_nueva_comm);
           IF v_comm_ok = 'OK' THEN
                dbms_output.put_line('Nueva comisión es ' || p_nueva_comm);
           ELSE  
              dbms_output.put_line( 'Comisión no corresponde');
      END IF;
    END SP_RESET_COMM;
END PKG_COMM;

--Ejemplo 2 de cuerpo de package
CREATE OR REPLACE PACKAGE BODY PKG_DATOS_EMP IS 
   FUNCTION FN_OBT_DEPTO(p_cod_depto NUMBER) RETURN VARCHAR2 IS
   BEGIN
          SELECT department_name INTO v_nombre_depto
             FROM departments
          WHERE department_id = p_cod_depto;
         RETURN v_nombre_depto;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN 'No existe Departamento';
    END FN_OBT_DEPTO;
END PKG_DATOS_EMP;


--PACKAGE Completo
CREATE OR REPLACE PACKAGE PKG_DATOS_EMP IS
v_nombre_depto VARCHAR2(50);
FUNCTION FN_OBT_DEPTO(p_cod_depto NUMBER) RETURN VARCHAR2;
END PKG_DATOS_EMP;

CREATE OR REPLACE PACKAGE BODY PKG_DATOS_EMP IS
   FUNCTION FN_OBT_DEPTO(p_cod_depto NUMBER) RETURN VARCHAR2 IS
   BEGIN
     SELECT department_name INTO v_nombre_depto
         FROM departments
      WHERE department_id = p_cod_depto;
  RETURN v_nombre_depto;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
  RETURN 'No existe Departamento';
  END FN_OBT_DEPTO;
END PKG_DATOS_EMP;

--Eliminar declaración y cuerpo del Package.
DROP PACKAGE nombre_package ;


--Eliminar el cuerpo del package.
DROP PACKAGE BODY nombre_package;



































--Experiencia 16 Triggers. 
--(before = antes - after= despues)

--Trigger a nivel de sentencia.
CREATE OR REPLACE TRIGGER TRG_SEGURIDAD_EMP
  BEFORE INSERT ON employees 
BEGIN
  IF (TO_CHAR(SYSDATE,'HH24:MI') NOT BETWEEN '08:00' AND '18:00') THEN
    RAISE_APPLICATION_ERROR(-20500, 'Se debe insertar en tabla EMPLOYEES sólo durante horas de trabajo.');
  END IF;
END;

--Utilizando el IF en un trigger.
CREATE OR REPLACE TRIGGER TRG_VALIDA_DML_EMP 
BEFORE INSERT OR UPDATE OR DELETE ON employees BEGIN
 IF TO_CHAR(SYSDATE,'HH24')  NOT BETWEEN '08' AND '18' THEN
       IF DELETING THEN 
           RAISE_APPLICATION_ERROR(-20502, 'Se debe eliminar desde tabla EMPLOYEES sólo durante horas de trabajo.');
       ELSIF INSERTING THEN 
            RAISE_APPLICATION_ERROR(-20500, 'Se debe insertar en tabla EMPLOYEES sólo durante horas de trabajo.');
       ELSIF UPDATING('SALARY') THEN
           RAISE_APPLICATION_ERROR(-20503, 'Se debe actualizar salario sólo durante horas de trabajo.');
       END IF;
 END IF;
END;

--Triggers con el NEW y el OLD. 
--(before = antes - after= despues)

--Creación de secuencias.
CREATE SEQUENCE SEQ_RESTRINGE_SAL;

--Creacion de tabla
CREATE TABLE VALIDA_SALARIOS
(sec_error    NUMBER(5) CONSTRAINT PK_VALIDA_SALARIOS PRIMARY KEY,
 id_empleado NUMBER(5) NOT NULL,
 desc_error    VARCHAR2(50) NOT NULL);

--Creacion de trigger.
CREATE OR REPLACE TRIGGER TRG_RESTRINGIR_SALARIO
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :NEW.job_id NOT IN ('AD_PRES', 'AD_VP')
       AND :NEW.salary > 15000 THEN
    INSERT INTO valida_salarios
    VALUES(seq_restringe_sal.NEXTVAL, :NEW.employee_id, 'Empleado no puede ganar más de $15,000.');
  END IF;
END;

--Ejemplo 2 de OLD Y NEW
CREATE TABLE audit_emp
(user_name              varchar2(30), 
 old_employee_id     number(5),
 new_employee_id   number(5),
 old_last_name         varchar2(30), 
 new_last_name       varchar2(30), 
 old_title                   varchar2(10), 
 new_title                 varchar2(10), 
 old_salary                number(8,2), 
 new_salary              number(8,2));

--Utilizando el trigger.
CREATE OR REPLACE TRIGGER TRG_AUDIT_EMP
AFTER DELETE OR INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_emp(user_name, old_employee_id, new_employee_id,old_last_name, new_last_name, old_title, new_title, old_salary, new_salary)
    VALUES (USER, :OLD.employee_id, :NEW.employee_id, :OLD.last_name, :NEW.last_name,:OLD.job_id, :NEW.job_id, :OLD.salary, :NEW.salary);
END;

select * from AUDIT_EMP;

--Trigger más complejo. (TRIGGER A NIVEL DE FILA)

--Creación de tabla.
CREATE TABLE comisiones
(id_empleado number(5),
  comision    number(5));

--Trigger que se ejecuta cuando se inserte , se actualice el salario o se elimine un usuario.
CREATE OR REPLACE TRIGGER  TRG_COMISION
BEFORE INSERT OR UPDATE OF SALARY OR DELETE ON employees
FOR EACH ROW
BEGIN
   IF INSERTING THEN
      INSERT INTO comisiones 
      VALUES(:NEW.employee_id, :NEW.salary * .25);
   ELSIF UPDATING THEN
        UPDATE comisiones
           SET comision = :NEW.salary *.25
         WHERE id_empleado = :NEW.employee_id;
   ELSE 
        DELETE FROM comisiones
         WHERE id_empleado = :OLD.employee_id;
   END IF;
END;

--Trigger chorizos con WHEN.
CREATE OR REPLACE TRIGGER  TRG_derive_commission_pct
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
WHEN (NEW.job_id = 'SA_REP')
BEGIN
   IF INSERTING THEN
        :NEW.commission_pct := 0;
   ELSE 
        :NEW.commission_pct := :OLD.commission_pct+0.05;
   END IF;
END;

--Eliminar un trigger.
DROP TRIGGER nombre_trigger;

--Activar o desactivar un trigger.
ALTER TRIGGER nombre_trigger  DISABLE | ENABLE;

--Activar o desactivar todos los trigger.
ALTER TABLE nombre_tabla DISABLE | ENABLE ALL TRIGGERS;


--Trigger que elimina la sentencia DML que lo origino , actua solo sobre vistas.
CREATE OR REPLACE TRIGGER TRG_V_DETALLE_EMPS 
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_detalle_emps  
FOR EACH ROW
BEGIN
   IF INSERTING THEN
        INSERT INTO datos_emps  
        VALUES (:NEW.employee_id,  :NEW.last_name,:NEW.salary,:NEW.department_id); 
       UPDATE salarios_por_depto 
              SET dept_sal = dept_sal + :NEW.salary
        WHERE department_id = :NEW.department_id;
   ELSIF DELETING THEN
        DELETE FROM datos_emps 
         WHERE employee_id = :OLD.employee_id;
        UPDATE salarios_por_depto 
               SET dept_sal = dept_sal - :OLD.salary
          WHERE department_id = :OLD.department_id; 
   ELSIF UPDATING ('salary') THEN
         UPDATE datos_emps 
                 SET salary = :NEW.salary
            WHERE employee_id = :OLD.employee_id;
         UPDATE salarios_por_depto 
                SET dept_sal = dept_sal + (:NEW.salary - :OLD.salary)
          WHERE department_id = :OLD.department_id;
   END IF;
END;
