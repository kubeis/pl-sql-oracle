declare
  probe_major_ver varchar2(10);
  probe_minor_ver varchar2(10);
begin
  dbms_debug.probe_version(probe_major_ver, probe_minor_ver);
  dbms_output.put_line('MAJOR=' || probe_major_ver);
  dbms_output.put_line('MINOR=' || probe_minor_ver);
end;
/
grant DEBUG CONNECT SESSION to HR;
/
CREATE OR REPLACE PROCEDURE loopproc (inval NUMBER) 
IS
  tmpvar   NUMBER;
  tmpvar2   NUMBER;
  total     NUMBER;
BEGIN
  tmpvar := 0;
  tmpvar2 := 0;
  total := 0;
  FOR lcv IN 1 .. inval
  LOOP
      total := 2 * total + 1 - tmpvar2;
      tmpvar2 := tmpvar;
      tmpvar := total;
  END LOOP;
  DBMS_OUTPUT.put_line ('TOTAL IS: ' || total);
END loopproc;
/

