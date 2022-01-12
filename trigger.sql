CREATE OR REPLACE TRIGGER print_salary_changes
  BEFORE DELETE OR INSERT OR UPDATE ON HR.EMPLOYEES
  FOR EACH ROW
WHEN (new.employees_id > 0)
DECLARE
    sal_diff number;
BEGIN
    sal_diff  := :new.sal  - :old.sal;
    dbms_output.put('Old salary: ' || :old.sal);
    dbms_output.put('  New salary: ' || :new.sal);
    dbms_output.put_line('Difference ' || sal_diff);
END;
/

DROP TRIGGER HR.UPDATE_JOB_HISTORY;

CREATE OR REPLACE TRIGGER HR.update_job_history
  AFTER UPDATE OF job_id, department_id ON HR.EMPLOYEES
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/




