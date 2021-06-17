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