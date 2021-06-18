CREATE OR REPLACE 
TYPE p_object IS OBJECT 
 ( name VARCHAR2(20),
   age  INTEGER);
/
CREATE OR REPLACE 
TYPE people IS OBJECT 
 ( race VARCHAR2(20),
   etat_civil p_object);
/

CREATE OR REPLACE 
TYPE people_table IS TABLE OF people;
                   

SELECT * FROM TABLE( select CAST(COLLECT(people( 'Men', p_object('Tom', 45))) as people_table) FROM DUAL);







