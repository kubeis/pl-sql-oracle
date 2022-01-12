SELECT last_name, employee_id, manager_id  
FROM HR.employees 
CONNECT BY PRIOR employee_id = manager_id 
   AND salary > commission_pct 
ORDER BY last_name;
/

SELECT LPAD(' ',2*(LEVEL-1)) || last_name org_chart, 
        employee_id, manager_id, job_id
    FROM hr.employees
    START WITH job_id = 'AD_VP' 
    CONNECT BY PRIOR employee_id = manager_id