CREATE OR REPLACE FUNCTION name_from_id (id_in IN INTEGER) 
   RETURN VARCHAR2 
   AUTHID DEFINER
IS
   l_the_name   EMPLOYEES.LAST_NAME%TYPE;
BEGIN
   EXECUTE IMMEDIATE 'select LAST_NAME
                        from EMPLOYEES 
                       where EMPLOYEE_ID = ' || id_in
      INTO l_the_name;
 
   RETURN l_the_name;
END;
/

SELECT name_from_id(104) from dual;

/

DECLARE
   TYPE name_salary_rt IS RECORD (
      name     VARCHAR2 (1000),
      salary   NUMBER
   );
 
   TYPE name_salary_aat IS TABLE OF name_salary_rt
      INDEX BY PLS_INTEGER;
 
   l_employees   name_salary_aat;
BEGIN
   EXECUTE IMMEDIATE
      q'[select first_name || ' ' || last_name, salary 
           from hr.employees
          order by salary desc]'
      BULK COLLECT INTO l_employees;
 
   FOR indx IN 1 .. l_employees.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_employees (indx).name || CHR(32) || l_employees (indx).salary);
   END LOOP;
END;

