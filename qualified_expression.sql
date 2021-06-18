-- example 1
DECLARE
   TYPE numbers_t IS TABLE OF NUMBER;
   l_numbers numbers_t := numbers_t (1, 2, 3 * 3);
BEGIN
   DBMS_OUTPUT.put_line (l_numbers.COUNT);
END;

-- example 2
DECLARE
   TYPE numbers_t IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
   l_numbers numbers_t;
BEGIN
   l_numbers (1) := 100;
   l_numbers (2) := 1000;
   l_numbers (3) := 10000;
END;

-- example 3
DECLARE
   TYPE person_rt IS 
      RECORD (last_name VARCHAR2(100), hair_color VARCHAR2(100));
   l_person person_rt;
BEGIN
   l_person.last_name := 'NobleProg';
   l_person.hair_color := 'Not Applicable';
END;

-- Qualified expression 
DECLARE 
   TYPE species_rt IS RECORD ( 
      species_name           VARCHAR2 (100), 
      habitat_type           VARCHAR2 (100), 
      surviving_population   INTEGER); 
 
   l_elephant   species_rt := species_rt ('Elephant', 'Savannah', '10000'); 
 
   PROCEDURE display_species ( 
      species_in species_rt DEFAULT species_rt ('Not Set', 'Global', 0)) 
   IS 
   BEGIN 
      DBMS_OUTPUT.put_line ('Species: ' || species_in.species_name); 
      DBMS_OUTPUT.put_line ('Habitat: ' || species_in.habitat_type); 
      DBMS_OUTPUT.put_line ('# Left: '  || species_in.surviving_population); 
   END; 
BEGIN 
   display_species (species_in => l_elephant); 
   /* Use the default */ 
   display_species (); 
END;
/
DECLARE 
   TYPE species_rt IS RECORD ( 
      species_name           VARCHAR2 (100), 
      habitat_type           VARCHAR2 (100), 
      surviving_population   INTEGER); 
 
   l_elephant   species_rt 
      := species_rt (species_name           => 'Elephant', 
                     surviving_population   => '10000', 
                     habitat_type           => 'Savannah'); 
BEGIN 
   DBMS_OUTPUT.put_line ('Species: ' || l_elephant.species_name); 
END;
/
DECLARE 
   TYPE ints_t IS TABLE OF INTEGER 
      INDEX BY PLS_INTEGER; 
 
   l_ints   ints_t := ints_t (1 => 55, 2 => 555, 3 => 5555); 
BEGIN 
   FOR indx IN 1 .. l_ints.COUNT 
   LOOP 
      DBMS_OUTPUT.put_line (l_ints (indx)); 
   END LOOP; 
END;
/

DECLARE 
   TYPE ints_t IS TABLE OF INTEGER 
      INDEX BY PLS_INTEGER; 
 
   l_ints   ints_t := ints_t (600 => 55, -5 => 555, 20000 => 5555); 
   l_index pls_integer := l_ints.first;
BEGIN 
   WHILE l_index IS NOT NULL
   LOOP 
      DBMS_OUTPUT.put_line (l_index ||  '=>' || l_ints(l_index));
      l_index := l_ints.NEXT(l_index); 
   END LOOP; 
END;
/
DECLARE 
   TYPE by_string_t IS TABLE OF INTEGER 
      INDEX BY VARCHAR2(100); 
 
   l_stuff   by_string_t := by_string_t ('Steven' => 55, 'Loey' => 555, 'Juna' => 5555); 
   l_index varchar2(100) := l_stuff.first; 
BEGIN 
   DBMS_OUTPUT.put_line (l_stuff.count); 
    
   WHILE l_index IS NOT NULL 
   LOOP 
      DBMS_OUTPUT.put_line (l_index || ' => ' || l_stuff (l_index)); 
      l_index := l_stuff.NEXT (l_index); 
   END LOOP; 
END;
/

-- index avec des functions
DECLARE
   TYPE by_string_t IS TABLE OF INTEGER
      INDEX BY VARCHAR2 (100);

   l_stuff   by_string_t := 
      by_string_t (UPPER ('Grandpa Steven') => 55, 
                   'Loey'||'Juna' => 555, 
                   SUBSTR ('Happy Family', 7) => 5555);

   l_index varchar2(100) := l_stuff.first;
BEGIN
   DBMS_OUTPUT.put_line (l_stuff.count);

   WHILE l_index IS NOT NULL
   LOOP
      DBMS_OUTPUT.put_line (l_index || ' => ' || l_stuff (l_index));
      l_index := l_stuff.NEXT (l_index);
   END LOOP;
END;
/

DECLARE
   TYPE species_rt IS RECORD (
      species_name VARCHAR2 (100),
      habitat_type VARCHAR2 (100),
      surviving_population INTEGER
   );
   
   TYPE species_t IS TABLE OF species_rt INDEX BY PLS_INTEGER;

   l_species   species_t := 
      species_t (
         2 => species_rt ('Elephant', 'Savannah', '10000'), 
         1 => species_rt ('Dodos', 'Mauritius', '0'), 
         3 => species_rt ('Venus Flytrap', 'North Carolina', '250'));
BEGIN
   FOR indx IN 1 .. l_species.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_species (indx).species_name);
   END LOOP;
END;
/