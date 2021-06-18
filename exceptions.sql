DECLARE 
    e EXCEPTION;
BEGIN
   RAISE e;
   DBMS_OUTPUT.PUT_LINE('Can''t get there');
EXCEPTION
  WHEN OTHERS THEN 
  IF SQLCODE = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('This is a ' || SQLERRM );
  END IF; 
END;


DECLARE 
   lv_a VARCHAR2(20);
   invalid_userenv_parameter EXCEPTION;
   PRAGMA EXCEPTION_INIT( invalid_userenv_parameter , -2003);
BEGIN 
   lv_a := SYS_CONTEXT('USERENV', 'PROXY_PUSHER');
EXCEPTION
   when invalid_userenv_parameter THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/




