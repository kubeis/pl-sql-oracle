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