DECLARE
   TYPE employee_info_t IS TABLE OF employees%ROWTYPE;
   l_employees   employee_info_t;
BEGIN
   SELECT *
     BULK COLLECT INTO l_employees
     FROM employees
    WHERE department_id = 50;
   DBMS_OUTPUT.PUT_LINE (l_employees.COUNT);
END;

DECLARE
   TYPE two_cols_rt IS RECORD (
      employee_id   employees.employee_id%TYPE,
      salary        employees.salary%TYPE
   );
   TYPE employee_info_t IS TABLE OF two_cols_rt;
   l_employees   employee_info_t;
BEGIN
   SELECT employee_id, salary
     BULK COLLECT INTO l_employees
     FROM employees
    WHERE department_id = 50;
   DBMS_OUTPUT.PUT_LINE (l_employees.COUNT);
END;

DECLARE
   CURSOR employee_info_c IS
      SELECT employee_id, salary 
        FROM employees;
   TYPE employee_info_t IS TABLE OF employee_info_c%ROWTYPE;
   l_employees   employee_info_t;
BEGIN
   SELECT employee_id, salary
     BULK COLLECT INTO l_employees
     FROM employees
    WHERE department_id = 50;
    DBMS_OUTPUT.PUT_LINE (l_employees.COUNT);
END;
/

DECLARE
   l_strings   DBMS_SQL.varchar2a;
BEGIN
   FOR indx IN 1 .. (2 ** 30)
   LOOP
      l_strings (indx) := RPAD ('abc', 32767, 'def');
   END LOOP;
END;

SELECT COUNT(*) FROM employees;

DECLARE
   c_limit PLS_INTEGER := 10;
   CURSOR employees_cur
   IS
      SELECT employee_id
        FROM employees
       WHERE department_id = 50;
   TYPE employee_ids_t IS TABLE OF 
      employees.employee_id%TYPE;
   l_employee_ids   employee_ids_t;
BEGIN
   OPEN employees_cur;
   LOOP
      FETCH employees_cur
      BULK COLLECT INTO l_employee_ids
      LIMIT c_limit;
      DBMS_OUTPUT.PUT_LINE (l_employee_ids.COUNT || ' fetched');
      EXIT WHEN l_employee_ids.COUNT = 0;
   END LOOP;
END;

DECLARE
   CURSOR emps_c IS SELECT * FROM employees;
   l_emp   emps_c%ROWTYPE;
   l_count INTEGER := 0;
BEGIN
   OPEN emps_c;
   LOOP
      FETCH emps_c INTO l_emp;
      EXIT WHEN emps_c%NOTFOUND;
      DBMS_OUTPUT.put_line (l_emp.employee_id);
      l_count := l_count + 1;
   END LOOP;
   DBMS_OUTPUT.put_line ('Total rows fetched: ' || l_count);
END;

DECLARE
   CURSOR emps_c IS SELECT * FROM employees;
   TYPE emps_t IS TABLE OF emps_c%ROwTYPE;
   l_emps   emps_t;
   l_count INTEGER := 0;
BEGIN
   OPEN emps_c;
   LOOP
      FETCH emps_c BULK COLLECT INTO l_emps LIMIT 10;
      EXIT WHEN emps_c%NOTFOUND;
      DBMS_OUTPUT.put_line (l_emps.COUNT);
      l_count := l_count + l_emps.COUNT;
   END LOOP;
   DBMS_OUTPUT.put_line ('Total rows fetched: ' || l_count);
END;

DECLARE
   CURSOR emps_c IS SELECT * FROM employees;
   TYPE emps_t IS TABLE OF emps_c%ROwTYPE;
   l_emps   emps_t;
   l_count INTEGER := 0;
BEGIN
   OPEN emps_c;
   LOOP
      FETCH emps_c BULK COLLECT INTO l_emps LIMIT 25;
      DBMS_OUTPUT.put_line ('Row fetched: ' || l_emps.COUNT);
      l_count := l_count + l_emps.COUNT;
      EXIT WHEN emps_c%NOTFOUND;
   END LOOP;
   DBMS_OUTPUT.put_line ('Total rows fetched: ' || l_count);
END;


DECLARE
    c_limit PLS_INTEGER := 5;
    CURSOR employees_cur IS
        SELECT LAST_NAME, SALARY
        FROM employees;
        
    TYPE employee_ids_t IS TABLE OF employees_cur%ROWTYPE;
   
    l_employee_ids   employee_ids_t;
    l_count INTEGER := 0;
BEGIN
    OPEN employees_cur;
    LOOP
        FETCH employees_cur BULK COLLECT INTO l_employee_ids LIMIT c_limit;
        
        FOR idx IN 1..l_employee_ids.count
        LOOP
            DBMS_OUTPUT.PUT_LINE ('Nom <' || l_employee_ids (idx).LAST_NAME || '>');
        END LOOP;
        
        FOR idx IN 1..l_employee_ids.count
        LOOP
            DBMS_OUTPUT.PUT_LINE ('Salaire <' || l_employee_ids (idx).SALARY || '>');
        END LOOP;
        
        l_count := l_count + l_employee_ids.count;
        
        EXIT WHEN employees_cur%NOTFOUND;
    END LOOP;
    DBMS_OUTPUT.put_line ('Total rows fetched: ' || l_count);
END;
