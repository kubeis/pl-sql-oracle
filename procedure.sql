select trunc(abs(dbms_random.value(1,20))) from dual;
/
drop table command;
/
CREATE TABLE command 
  (   command_id   integer,
      company_id   integer
  );
/
INSERT INTO command VALUES ( 1, 50);
/
INSERT INTO command VALUES ( 2, 50);
/
INSERT INTO command VALUES ( 3, 20);
/
INSERT INTO command VALUES ( 4, 30);
/
INSERT INTO command VALUES ( 5, 40);
/
INSERT INTO command VALUES ( 6, 50);
/
select * from command;

CREATE TABLE item 
  (   item_id   integer,
      command_id   integer,
      amount NUMBER (5,2)
  );
/
INSERT INTO item VALUES ( 1, 20, 11.23);
/
INSERT INTO item VALUES ( 2, 30, 289.34);
/
INSERT INTO item VALUES ( 3, 50, 445.45);
/
INSERT INTO item VALUES ( 4, 50, 556.67);
/

select * from item;


DROP PROCEDURE apply_discount;
/
PROCEDURE apply_discount
 ( company_id_in IN company.company_id%TYPE, discount_in IN NUMBER)
IS
  min_discount CONSTANT NUMBER := 0.5;
  max_discount CONSTANT NUMBER := 0.25;
  invalid_discount EXCEPTION;
 BEGIN
  IF discount_in BETWEEN min_discount AND max_discount
    THEN 
      UPDATE item
        SET item_amount = item_amount*(1-discount_in)
      where EXISTS( select 'x' FROM command 
            where    command.command_id = item.command_id
                 and command.company_id = company_id_in ); 
      if SQL%ROWCOUNT = 0 THEN RAISE NO_DATA_FOUND; END IF;
  ELSE
    RAISE invalid_discount;
  END IF;
  EXCEPTION
  WHEN invalid_discount
  THEN
    DBMS_OUTPUT.PUT_LINE(' The specified discount is invalid.');
  WHEN NO_DATA_FOUND
  THEN
    DBMS_OUTPUT.PUT_LINE(' No order in the system for company: ' || 
      TO_CHAR(company_id_in));
END apply_discount;
BEGIN
  apply_discount(50, 0.17);
end;