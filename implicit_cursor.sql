DECLARE 
    count_emp NUMBER ;
    count_dep NUMBER;
BEGIN
    select count(*) INTO count_emp FROM EMPLOYEES; 
    select count(*) INTO Count_dep FROM DEPARTMENTS;
END;
/

DECLARE 
    l_ename EMPLOYEES.FIRST_NAME%TYPE;
    l_sal   EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT first_name, salary into l_ename, l_sal FROM EMPLOYEES 
     WHERE EMPLOYEES.EMPLOYEE_ID = 177;
     DBMS_OUTPUT.PUT_LINE('Rows selected ' || SQL%ROWCOUNT );
END;
/

CREATE OR REPLACE PROCEDURE increase_salary (
   department_id_in   IN employees.department_id%TYPE,
   increase_pct_in    IN NUMBER)
IS
BEGIN
   FOR employee_rec
      IN (SELECT employee_id
            FROM employees
           WHERE department_id =
                    increase_salary.department_id_in)
   LOOP
      UPDATE employees emp
         SET emp.salary = emp.salary + 
             emp.salary * increase_salary.increase_pct_in
       WHERE emp.employee_id = employee_rec.employee_id;
      DBMS_OUTPUT.PUT_LINE ('Updated ' || SQL%ROWCOUNT);
   END LOOP;
END increase_salary;
BEGIN 
    increase_salary (50, .10);
    ROLLBACK;
END;