DROP TABLE t_fun_plsql;
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