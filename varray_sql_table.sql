CREATE OR REPLACE
  TYPE sql_varray IS VARRAY(3) OF VARCHAR2(20);
/
SELECT column_value AS Devteam
FROM  TABLE(sql_varray('tom','joe','adam'));
/

DECLARE 
    lv_name SQL_VARRAY := sql_varray('Test','product');
BEGIN
   dbms_output.put_line ( 'Count [ ' || lv_name.COUNT || '] Limit [' || lv_name.LIMIT || '] ' );
   lv_name.EXTEND;
   dbms_output.put_line ( 'Count [ ' || lv_name.COUNT || '] Limit [' || lv_name.LIMIT || '] ' );
   lv_name(lv_name.COUNT) := 'Application';
   FOR i IN 1.. lv_name.COUNT  LOOP
    dbms_output.put_line (lv_name(i));
   END LOOP;
END;


CREATE OR REPLACE
  TYPE sql_table IS TABLE OF VARCHAR2(20);
  
SELECT column_value AS Prodteam
FROM  TABLE(sql_table('john','Tina','Mike'))
ORDER BY 1;
/

CREATE or REPLACE FUNCTION add_element
( pv_table  SQL_TABLE, pv_ELEMENT VARCHAR2 )  
RETURN SQL_TABLE IS
lv_table SQL_TABLE := sql_table();
BEGIN 
  IF pv_table.EXISTS(1) THEN 
    lv_table := pv_table;
  END IF;
  IF pv_element IS NOT NULL THEN 
     lv_table.EXTEND;
     lv_table(lv_table.COUNT) := pv_element;
  END IF;
  RETURN lv_table;
END;
/

 select column_value AS test
 FROM TABLE(add_element(sql_table('john','Tina','Mike'), 'Tom'))
 ORDER BY 1;         
    
    
    
    
    
  