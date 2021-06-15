DROP TABLE HR.JOBS CASCADE CONSTRAINTS;

CREATE TABLE HR.JOBS
(
  JOB_ID      VARCHAR2(10 BYTE),
  JOB_TITLE   VARCHAR2(35 BYTE) CONSTRAINT JOB_TITLE_NN NOT NULL,
  MIN_SALARY  NUMBER(6),
  MAX_SALARY  NUMBER(6)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;

COMMENT ON TABLE HR.JOBS IS 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';

COMMENT ON COLUMN HR.JOBS.JOB_ID IS 'Primary key of jobs table.';

COMMENT ON COLUMN HR.JOBS.JOB_TITLE IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

COMMENT ON COLUMN HR.JOBS.MIN_SALARY IS 'Minimum salary for a job title.';

COMMENT ON COLUMN HR.JOBS.MAX_SALARY IS 'Maximum salary for a job title';


CREATE UNIQUE INDEX HR.JOB_ID_PK ON HR.JOBS
(JOB_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE HR.JOBS ADD (
  CONSTRAINT JOB_ID_PK
  PRIMARY KEY
  (JOB_ID)
  USING INDEX HR.JOB_ID_PK
  ENABLE VALIDATE);


DROP TABLE HR.JOB_HISTORY CASCADE CONSTRAINTS;

CREATE TABLE HR.JOB_HISTORY
(
  EMPLOYEE_ID    NUMBER(6) CONSTRAINT JHIST_EMPLOYEE_NN NOT NULL,
  START_DATE     DATE CONSTRAINT JHIST_START_DATE_NN NOT NULL,
  END_DATE       DATE CONSTRAINT JHIST_END_DATE_NN NOT NULL,
  JOB_ID         VARCHAR2(10 BYTE) CONSTRAINT JHIST_JOB_NN NOT NULL,
  DEPARTMENT_ID  NUMBER(4)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;

COMMENT ON TABLE HR.JOB_HISTORY IS 'Table that stores job history of the employees. If an employee
changes departments within the job or changes jobs within the department,
new rows get inserted into this table with old job information of the
employee. Contains a complex primary key: employee_id+start_date.
Contains 25 rows. References with jobs, employees, and departments tables.';

COMMENT ON COLUMN HR.JOB_HISTORY.EMPLOYEE_ID IS 'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';

COMMENT ON COLUMN HR.JOB_HISTORY.START_DATE IS 'A not null column in the complex primary key employee_id+start_date.
Must be less than the end_date of the job_history table. (enforced by
constraint jhist_date_interval)';

COMMENT ON COLUMN HR.JOB_HISTORY.END_DATE IS 'Last day of the employee in this job role. A not null column. Must be
greater than the start_date of the job_history table.
(enforced by constraint jhist_date_interval)';

COMMENT ON COLUMN HR.JOB_HISTORY.JOB_ID IS 'Job role in which the employee worked in the past; foreign key to
job_id column in the jobs table. A not null column.';

COMMENT ON COLUMN HR.JOB_HISTORY.DEPARTMENT_ID IS 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';


CREATE UNIQUE INDEX HR.JHIST_EMP_ID_ST_DATE_PK ON HR.JOB_HISTORY
(EMPLOYEE_ID, START_DATE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE HR.JOB_HISTORY ADD (
  CONSTRAINT JHIST_DATE_INTERVAL
  CHECK (end_date > start_date)
  ENABLE VALIDATE
,  CONSTRAINT JHIST_EMP_ID_ST_DATE_PK
  PRIMARY KEY
  (EMPLOYEE_ID, START_DATE)
  USING INDEX HR.JHIST_EMP_ID_ST_DATE_PK
  ENABLE VALIDATE);


DROP TABLE HR.REGIONS CASCADE CONSTRAINTS;

CREATE TABLE HR.REGIONS
(
  REGION_ID    NUMBER CONSTRAINT REGION_ID_NN   NOT NULL,
  REGION_NAME  VARCHAR2(25 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


CREATE UNIQUE INDEX HR.REG_ID_PK ON HR.REGIONS
(REGION_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE HR.REGIONS ADD (
  CONSTRAINT REG_ID_PK
  PRIMARY KEY
  (REGION_ID)
  USING INDEX HR.REG_ID_PK
  ENABLE VALIDATE);


CREATE INDEX HR.JHIST_DEPARTMENT_IX ON HR.JOB_HISTORY
(DEPARTMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.JHIST_EMPLOYEE_IX ON HR.JOB_HISTORY
(EMPLOYEE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.JHIST_JOB_IX ON HR.JOB_HISTORY
(JOB_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

DROP TABLE HR.COUNTRIES CASCADE CONSTRAINTS;

CREATE TABLE HR.COUNTRIES
(
  COUNTRY_ID    CHAR(2 BYTE) CONSTRAINT COUNTRY_ID_NN NOT NULL,
  COUNTRY_NAME  VARCHAR2(40 BYTE),
  REGION_ID     NUMBER, 
  CONSTRAINT COUNTRY_C_ID_PK
  PRIMARY KEY
  (COUNTRY_ID)
  ENABLE VALIDATE
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

COMMENT ON TABLE HR.COUNTRIES IS 'country table. Contains 25 rows. References with locations table.';

COMMENT ON COLUMN HR.COUNTRIES.COUNTRY_ID IS 'Primary key of countries table.';

COMMENT ON COLUMN HR.COUNTRIES.COUNTRY_NAME IS 'Country name';

COMMENT ON COLUMN HR.COUNTRIES.REGION_ID IS 'Region ID for the country. Foreign key to region_id column in the departments table.';


-- Index COUNTRY_C_ID_PK is created automatically by Oracle with index organized table COUNTRIES.

DROP TABLE HR.LOCATIONS CASCADE CONSTRAINTS;

CREATE TABLE HR.LOCATIONS
(
  LOCATION_ID     NUMBER(4),
  STREET_ADDRESS  VARCHAR2(40 BYTE),
  POSTAL_CODE     VARCHAR2(12 BYTE),
  CITY            VARCHAR2(30 BYTE) CONSTRAINT LOC_CITY_NN NOT NULL,
  STATE_PROVINCE  VARCHAR2(25 BYTE),
  COUNTRY_ID      CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;

COMMENT ON TABLE HR.LOCATIONS IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';

COMMENT ON COLUMN HR.LOCATIONS.LOCATION_ID IS 'Primary key of locations table';

COMMENT ON COLUMN HR.LOCATIONS.STREET_ADDRESS IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN HR.LOCATIONS.POSTAL_CODE IS 'Postal code of the location of an office, warehouse, or production site
of a company. ';

COMMENT ON COLUMN HR.LOCATIONS.CITY IS 'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';

COMMENT ON COLUMN HR.LOCATIONS.STATE_PROVINCE IS 'State or Province where an office, warehouse, or production site of a
company is located.';

COMMENT ON COLUMN HR.LOCATIONS.COUNTRY_ID IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';


CREATE UNIQUE INDEX HR.LOC_ID_PK ON HR.LOCATIONS
(LOCATION_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE HR.LOCATIONS ADD (
  CONSTRAINT LOC_ID_PK
  PRIMARY KEY
  (LOCATION_ID)
  USING INDEX HR.LOC_ID_PK
  ENABLE VALIDATE);


CREATE INDEX HR.LOC_CITY_IX ON HR.LOCATIONS
(CITY)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.LOC_COUNTRY_IX ON HR.LOCATIONS
(COUNTRY_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.LOC_STATE_PROVINCE_IX ON HR.LOCATIONS
(STATE_PROVINCE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

DROP TABLE HR.DEPARTMENTS CASCADE CONSTRAINTS;

CREATE TABLE HR.DEPARTMENTS
(
  DEPARTMENT_ID    NUMBER(4),
  DEPARTMENT_NAME  VARCHAR2(30 BYTE) CONSTRAINT DEPT_NAME_NN NOT NULL,
  MANAGER_ID       NUMBER(6),
  LOCATION_ID      NUMBER(4)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;

COMMENT ON TABLE HR.DEPARTMENTS IS 'Departments table that shows details of departments where employees
work. Contains 27 rows; references with locations, employees, and job_history tables.';

COMMENT ON COLUMN HR.DEPARTMENTS.DEPARTMENT_ID IS 'Primary key column of departments table.';

COMMENT ON COLUMN HR.DEPARTMENTS.DEPARTMENT_NAME IS 'A not null column that shows name of a department. Administration,
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN HR.DEPARTMENTS.MANAGER_ID IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';

COMMENT ON COLUMN HR.DEPARTMENTS.LOCATION_ID IS 'Location id where a department is located. Foreign key to location_id column of locations table.';


CREATE UNIQUE INDEX HR.DEPT_ID_PK ON HR.DEPARTMENTS
(DEPARTMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE HR.DEPARTMENTS ADD (
  CONSTRAINT DEPT_ID_PK
  PRIMARY KEY
  (DEPARTMENT_ID)
  USING INDEX HR.DEPT_ID_PK
  ENABLE VALIDATE);


DROP TABLE HR.EMPLOYEES CASCADE CONSTRAINTS;

CREATE TABLE HR.EMPLOYEES
(
  EMPLOYEE_ID     NUMBER(6),
  FIRST_NAME      VARCHAR2(20 BYTE),
  LAST_NAME       VARCHAR2(25 BYTE) CONSTRAINT EMP_LAST_NAME_NN NOT NULL,
  EMAIL           VARCHAR2(25 BYTE) CONSTRAINT EMP_EMAIL_NN NOT NULL,
  PHONE_NUMBER    VARCHAR2(20 BYTE),
  HIRE_DATE       DATE CONSTRAINT EMP_HIRE_DATE_NN NOT NULL,
  JOB_ID          VARCHAR2(10 BYTE) CONSTRAINT EMP_JOB_NN NOT NULL,
  SALARY          NUMBER(8,2),
  COMMISSION_PCT  NUMBER(2,2),
  MANAGER_ID      NUMBER(6),
  DEPARTMENT_ID   NUMBER(4)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;

COMMENT ON TABLE HR.EMPLOYEES IS 'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';

COMMENT ON COLUMN HR.EMPLOYEES.EMPLOYEE_ID IS 'Primary key of employees table.';

COMMENT ON COLUMN HR.EMPLOYEES.FIRST_NAME IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN HR.EMPLOYEES.LAST_NAME IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN HR.EMPLOYEES.EMAIL IS 'Email id of the employee';

COMMENT ON COLUMN HR.EMPLOYEES.PHONE_NUMBER IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN HR.EMPLOYEES.HIRE_DATE IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN HR.EMPLOYEES.JOB_ID IS 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';

COMMENT ON COLUMN HR.EMPLOYEES.SALARY IS 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';

COMMENT ON COLUMN HR.EMPLOYEES.COMMISSION_PCT IS 'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';

COMMENT ON COLUMN HR.EMPLOYEES.MANAGER_ID IS 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN HR.EMPLOYEES.DEPARTMENT_ID IS 'Department id where employee works; foreign key to department_id
column of the departments table';


CREATE UNIQUE INDEX HR.EMP_EMAIL_UK ON HR.EMPLOYEES
(EMAIL)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
CREATE UNIQUE INDEX HR.EMP_EMP_ID_PK ON HR.EMPLOYEES
(EMPLOYEE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE HR.EMPLOYEES ADD (
  CONSTRAINT EMP_SALARY_MIN
  CHECK (salary > 0)
  ENABLE VALIDATE
,  CONSTRAINT EMP_EMP_ID_PK
  PRIMARY KEY
  (EMPLOYEE_ID)
  USING INDEX HR.EMP_EMP_ID_PK
  ENABLE VALIDATE
,  CONSTRAINT EMP_EMAIL_UK
  UNIQUE (EMAIL)
  USING INDEX HR.EMP_EMAIL_UK
  ENABLE VALIDATE);


CREATE INDEX HR.DEPT_LOCATION_IX ON HR.DEPARTMENTS
(LOCATION_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.EMP_DEPARTMENT_IX ON HR.EMPLOYEES
(DEPARTMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.EMP_JOB_IX ON HR.EMPLOYEES
(JOB_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.EMP_MANAGER_IX ON HR.EMPLOYEES
(MANAGER_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX HR.EMP_NAME_IX ON HR.EMPLOYEES
(LAST_NAME, FIRST_NAME)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE OR REPLACE TRIGGER HR.secure_employees
  BEFORE INSERT OR UPDATE OR DELETE ON HR.EMPLOYEES
DISABLE
BEGIN
  secure_dml;
END secure_employees;
/


CREATE OR REPLACE TRIGGER HR.update_job_history
  AFTER UPDATE OF job_id, department_id ON HR.EMPLOYEES
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


ALTER TABLE HR.JOB_HISTORY ADD (
  CONSTRAINT JHIST_DEPT_FK 
  FOREIGN KEY (DEPARTMENT_ID) 
  REFERENCES HR.DEPARTMENTS (DEPARTMENT_ID)
  ENABLE VALIDATE
,  CONSTRAINT JHIST_EMP_FK 
  FOREIGN KEY (EMPLOYEE_ID) 
  REFERENCES HR.EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE
,  CONSTRAINT JHIST_JOB_FK 
  FOREIGN KEY (JOB_ID) 
  REFERENCES HR.JOBS (JOB_ID)
  ENABLE VALIDATE);

ALTER TABLE HR.COUNTRIES ADD (
  CONSTRAINT COUNTR_REG_FK 
  FOREIGN KEY (REGION_ID) 
  REFERENCES HR.REGIONS (REGION_ID)
  ENABLE VALIDATE);

ALTER TABLE HR.LOCATIONS ADD (
  CONSTRAINT LOC_C_ID_FK 
  FOREIGN KEY (COUNTRY_ID) 
  REFERENCES HR.COUNTRIES (COUNTRY_ID)
  ENABLE VALIDATE);

ALTER TABLE HR.DEPARTMENTS ADD (
  CONSTRAINT DEPT_LOC_FK 
  FOREIGN KEY (LOCATION_ID) 
  REFERENCES HR.LOCATIONS (LOCATION_ID)
  ENABLE VALIDATE
,  CONSTRAINT DEPT_MGR_FK 
  FOREIGN KEY (MANAGER_ID) 
  REFERENCES HR.EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE);

ALTER TABLE HR.EMPLOYEES ADD (
  CONSTRAINT EMP_DEPT_FK 
  FOREIGN KEY (DEPARTMENT_ID) 
  REFERENCES HR.DEPARTMENTS (DEPARTMENT_ID)
  ENABLE VALIDATE
,  CONSTRAINT EMP_JOB_FK 
  FOREIGN KEY (JOB_ID) 
  REFERENCES HR.JOBS (JOB_ID)
  ENABLE VALIDATE
,  CONSTRAINT EMP_MANAGER_FK 
  FOREIGN KEY (MANAGER_ID) 
  REFERENCES HR.EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE);

--
-- Note: 
-- The following objects may not be sorted properly in the script due to circular references
--
--  DEPARTMENTS  (Table) 
--  EMPLOYEES  (Table) 
--  DEPT_ID_PK  (Index) 
--  DEPT_LOCATION_IX  (Index) 
--  EMP_DEPARTMENT_IX  (Index) 
--  EMP_EMAIL_UK  (Index) 
--  EMP_EMP_ID_PK  (Index) 
--  EMP_JOB_IX  (Index) 
--  EMP_MANAGER_IX  (Index) 
--  EMP_NAME_IX  (Index) 
--  SECURE_EMPLOYEES  (Trigger) 
--  UPDATE_JOB_HISTORY  (Trigger)
