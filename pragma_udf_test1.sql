/* create a standalone function without pragma */
CREATE OR REPLACE FUNCTION f_count_num(p_str VARCHAR2)
RETURN  PLS_INTEGER IS
BEGIN
    RETURN (REGEXP_COUNT(p_str,'\d'));
END;
/
/*Set server output on to display messages*/
/
SET SERVEROUTPUT ON
/
/* Anonymous block to measure performance of a standalone function*/
DECLARE
    l_el_time PLS_INTEGER;
    l_cpu_time PLS_INTEGER;
    CURSOR C1 IS
        SELECT f_count_num (str) FROM t_fun_plsql;
    TYPE t_tab_rec IS TABLE OF PLS_INTEGER;
    l_tab t_tab_rec;
BEGIN
    l_el_time := DBMS_UTILITY.GET_TIME ();
    l_cpu_time := DBMS_UTILITY.GET_CPU_TIME ();
    OPEN c1;
    FETCH c1 BULK COLLECT INTO l_tab;
    CLOSE c1;
    DBMS_OUTPUT.PUT_LINE ('Case 1: Performance of a standalone function');
    DBMS_OUTPUT.PUT_LINE ('Total elapsed time:'||to_char(DBMS_UTILITY.GET_TIME () - l_el_time));
    DBMS_OUTPUT.PUT_LINE ('Total CPU time:'||to_char(DBMS_UTILITY.GET_CPU_TIME () - l_cpu_time));
END;
/
