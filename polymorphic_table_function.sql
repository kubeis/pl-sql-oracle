create or replace package hide_and_add_cols_pkg as 
 
  function describe ( 
    tab        in out dbms_tf.table_t, 
    add_cols   dbms_tf.columns_t, 
    hide_cols  dbms_tf.columns_t 
  ) return dbms_tf.describe_t; 
 
  procedure fetch_rows; 
 
end hide_and_add_cols_pkg;  


create or replace function hide_existing_add_new_cols (
  tab       table, 
  add_cols  columns, 
  hide_cols columns
) return table pipelined 
  row polymorphic 
  using hide_and_add_cols_pkg;
/  
  
create or replace package body hide_and_add_cols_pkg as 
 
  function describe ( 
    tab        in out dbms_tf.table_t, 
    add_cols   dbms_tf.columns_t, 
    hide_cols  dbms_tf.columns_t 
  ) return dbms_tf.describe_t as 
    new_cols dbms_tf.columns_new_t; 
    col_list dbms_tf.columns_t := add_cols; 
  begin 
     
    for i in 1 .. tab.column.count loop 
     
      if tab.column(i).description.name  
         member of hide_cols then 
          
        tab.column(i).for_read := false; 
        tab.column(i).pass_through := false; 
         
      end if; 
       
    end loop; 
   
    for i in 1 .. col_list.count loop 
 
      new_cols(i) := dbms_tf.column_metadata_t ( 
        name => col_list(i),  
        type => dbms_tf.type_number 
      );  
 
    end loop; 
 
    return dbms_tf.describe_t (  
      new_columns => new_cols 
    ); 
 
  end describe; 
 
  procedure fetch_rows  
  as 
    env       dbms_tf.env_t; 
    col       dbms_tf.tab_number_t; 
    last_row  pls_integer := 0; 
  begin 
     
    env := dbms_tf.get_env(); 
 
    for cols in 1 .. env.put_columns.count loop 
     
      dbms_tf.xstore_get('col' || cols, last_row);  
 
      for rws in 1 .. env.row_count loop 
        col ( rws ) := ( rws + last_row ) * cols; 
      end loop; 
      
      dbms_tf.put_col ( cols, col ); 
 
      dbms_tf.xstore_set('col' || cols, last_row + env.row_count); 
       
    end loop; 
 
  end fetch_rows; 
   
end hide_and_add_cols_pkg;  
/
create or replace function hide_existing_add_new_cols ( 
  tab       table,  
  add_cols  columns,  
  hide_cols columns 
) return table pipelined  
  row polymorphic  
  using hide_and_add_cols_pkg; 
/
-- example 
select *  
from   hide_existing_add_new_cols (  
  dual, columns ( c1 ), columns ( dummy ) 
);
/
with rws as (  
  select dummy from dual 
  connect by level <= 4 
) 
  select *  
  from   hide_existing_add_new_cols (  
    rws, columns ( c1, c2, c3, c4 ), columns ( not_here ) 
  );
 / 
 
select *  
from   hide_existing_add_new_cols (  
  ( select dummy from dual ),  
  columns ( c1 ),  
  columns ( dummy ) 
);
/
 create or replace function hide_existing_add_new_cols ( 
  tab       table,  
  add_cols  columns,  
  hide_cols columns 
) return table pipelined  
  table polymorphic  
  using hide_and_add_cols_pkg;  
 / 
-- example table
create table integers as 
  select level number_value, 
         case mod ( level, 2 )  
           when 0 then 'Y' 
           when 1 then 'N' 
         end is_even, 
         -level negated_value 
  from   dual 
  connect by level <= 6
;
/
select *  
from   hide_existing_add_new_cols (  
  integers 
    order by negated_value,  
  columns ( c1, c2 ),  
  columns ( is_even ) 
) 
order  by number_value;
/

select *  
from   hide_existing_add_new_cols (  
  integers 
    partition by is_even 
    order by number_value,  
  columns ( c1, c2 ),  
  columns ( negated_value ) 
) 
order by is_even, number_value



 
  
  