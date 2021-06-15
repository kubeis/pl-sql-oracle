CREATE TABLE  t_fun_plsql
( id number,
  str varchar2(30)
)
/
INSERT /* +APPEND */ INTO  t_fun_plsql
SELECT ROWNUM, DBMS_RANDOM.STRING('X',20)
FROM dual
CONNECT BY  LEVEL <= 1000000
/
COMMIT
/

select count(*) from t_fun_plsql;
-- check plan 
-- faire un analyze
/
analyze table t_fun_plsql compute statistics;
/
select count(*) from t_fun_plsql;
-- explain  IO cost:  1160
/
-- add a primary key
ALTER TABLE t_fun_plsql
ADD CONSTRAINT  pk_t_fun_plsql 
PRIMARY KEY (id);

select count(*) from t_fun_plsql;
-- explain  IO: cost 567

select count(id) from t_fun_plsql;
-- explain  IO: cost 567

analyze index pk_t_fun_plsql compute statistics;


ALTER TABLE t_fun_plsql
DROP CONSTRAINT  pk_t_fun_plsql 
 
