SET SERVEROUTPUT ON;
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
   ROLLBACK; -- to leave the table in its original state
END;


CREATE OR REPLACE PROCEDURE increase_salary (
   department_id_in   IN employees.department_id%TYPE,
   increase_pct_in    IN NUMBER)
IS
BEGIN
   UPDATE employees emp
      SET emp.salary =
               emp.salary
             + emp.salary * increase_salary.increase_pct_in
    WHERE emp.department_id = 
             increase_salary.department_id_in;
END increase_salary;