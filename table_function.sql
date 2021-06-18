-- table function

CREATE OR REPLACE FUNCTION longer_string (
   string_in IN VARCHAR2, to_length_in IN INTEGER)
   RETURN VARCHAR2
   AUTHID DEFINER
IS
BEGIN
   RETURN RPAD (string_in, to_length_in, 'x');
END;
/
CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100);
/

CREATE OR REPLACE FUNCTION random_strings (
   count_in IN INTEGER)
   RETURN strings_t
   AUTHID DEFINER
IS
   l_strings   strings_t := strings_t ();
BEGIN
   l_strings.EXTEND (count_in);

   FOR indx IN 1 .. count_in
   LOOP
      l_strings (indx) := DBMS_RANDOM.string ('x', 30);
   END LOOP;

   RETURN l_strings;
END;
/
DECLARE
   l_strings   strings_t := random_strings (5);
BEGIN
   FOR indx IN 1 .. l_strings.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_strings (indx));
   END LOOP;
END;
/
SELECT COLUMN_VALUE my_string
  FROM TABLE (random_strings (5))
/

CREATE OR REPLACE TYPE two_strings_ot
   AUTHID DEFINER IS OBJECT
(
   string1 VARCHAR2 (10),
   string2 VARCHAR2 (10)
)
/
CREATE OR REPLACE TYPE two_strings_nt IS TABLE OF two_strings_ot
/
CREATE OR REPLACE FUNCTION three_pairs
   RETURN two_strings_nt
   AUTHID DEFINER
IS
   l_strings   two_strings_nt;
BEGIN
   RETURN two_strings_nt (two_strings_ot ('a', 'b'),
                          two_strings_ot ('c', 'd'),
                          two_strings_ot ('e', 'f'));
END;
/
SELECT string1, string2 FROM TABLE (three_pairs ())
/


CREATE TABLE string_pairs
(
   string1   VARCHAR2 (10),
   string2   VARCHAR2 (10)
)
/
BEGIN
   INSERT INTO string_pairs
        VALUES ('a', 'bb');

   INSERT INTO string_pairs
        VALUES ('cc', 'dd');

   COMMIT;
END;
/

SELECT * FROM string_pairs
UNION ALL
SELECT * FROM TABLE (three_pairs ())
/
SELECT sp.string1, 
         sp.string2 sp_string2, 
         p3.string2 ps_string2
    FROM string_pairs sp, TABLE (three_pairs ()) p3
   WHERE sp.string1 = p3.string1
ORDER BY string1
/