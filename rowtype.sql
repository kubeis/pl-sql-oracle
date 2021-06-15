DECLARE
   emp_rec   employees%ROWTYPE;
   my_empno  employees.employee_id%TYPE := 100;
   CURSOR c1 IS
      SELECT department_id, department_name, location_id FROM departments;
   --dept_rec  c1%ROWTYPE;
BEGIN
   SELECT * INTO emp_rec FROM employees WHERE employee_id = my_empno;
   IF (emp_rec.department_id = 20) AND (emp_rec.salary > 2000) THEN
      NULL;
   END IF;
END;
/