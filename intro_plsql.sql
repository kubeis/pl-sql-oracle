BEGIN
  DBMS_OUTPUT.PUT_LINE(SYSDATE);
END;
/
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
/
BEGIN
  DBMS_OUTPUT.PUT_LINE(SYSDATE);
END;
/
DECLARE
  l_right_now VARCHAR2(30);
BEGIN
l_right_now := SYSDATE;
  DBMS_OUTPUT.PUT_LINE (l_right_now);
END;
/
DECLARE
  l_right_now VARCHAR2(9);
BEGIN
  l_right_now := SYSDATE;
DBMS_OUTPUT.PUT_LINE (l_right_now);
EXCEPTION
  WHEN VALUE_ERROR
  THEN
    DBMS_OUTPUT.PUT_LINE('I bet l_right_now is too small '
        || 'for the default date format!');
END;