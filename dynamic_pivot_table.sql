create or replace package dynamic_pivot_ptf_pkg as   
   
  function describe (  
    tab       in out  dbms_tf.table_t,    
    pivot_col dbms_tf.columns_t,  
    col_query varchar2  
  ) return dbms_tf.describe_t;   
  
  procedure fetch_rows ( col_query varchar2 ) ;  
   
end dynamic_pivot_ptf_pkg;   
/
create or replace package body dynamic_pivot_ptf_pkg as   
  
  type column_values is table of pls_integer  
    index by varchar2(128);  
  
  function get_column_names (  
    col_query varchar2  
  ) return dbms_tf.columns_new_t as  
      
    new_cols  dbms_tf.columns_new_t;  
    col_names dbms_sql.varchar2s;  
    cols_cur  sys_refcursor;  
      
  begin  
    
    open cols_cur for col_query;  
      
    fetch cols_cur  
    bulk  collect  
    into  col_names;  
      
    for c in 1 .. col_names.count loop  
      new_cols ( c ) := dbms_tf.column_metadata_t (  
        name => '"' || col_names ( c ) || '"',   
        type => dbms_tf.type_number  
      );   
    end loop;  
    
    return new_cols;  
      
  end;  
     
  function describe (  
    tab  in out  dbms_tf.table_t,    
    pivot_col dbms_tf.columns_t,    
    col_query varchar2  
  ) return dbms_tf.describe_t as   
    
    new_cols  dbms_tf.columns_new_t;   
      
  begin   
  
    for i in 1 .. tab.column.count loop     
      for j in 1 .. pivot_col.count loop   
        if ( tab.column(i).description.name = pivot_col ( j ) ) then  
          tab.column(i).pass_through := false;  
          tab.column(i).for_read     := true;   
        end if;  
      end loop;   
    end loop;   
  
    new_cols := get_column_names ( col_query );  
  
    return dbms_tf.describe_t (   
             new_columns     => new_cols,   
             row_replication => true  
           );   
  end;   
    
  procedure get_pivoted_column_values (  
    rowset                 dbms_tf.row_set_t,   
    rowcnt                 pls_integer,   
    col_vals               out column_values,  
    row_replication_factor out dbms_tf.tab_naturaln_t  
  ) as  
      
    col_val  varchar2(128);  
    col_name varchar2(128);  
      
  begin  
    
    for i in 1 .. rowcnt loop  
      /* Suppress all but the first row in the result set */  
      if i > 1 then  
        row_replication_factor ( i ) := 0;  
      else  
        row_replication_factor ( i ) := 1;  
      end if;  
        
      /* Get the value of the pivoted column based on its data type  
        (only supports varchar2 & number at the moment)  
      */  
      if rowset ( 1 ).description.type = dbms_tf.type_number then  
        dbms_tf.trace (   
          msg => rowset ( 1 ).tab_number ( i )  
        );  
  
        col_val := '"' || rowset ( 1 ).tab_number ( i ) || '"';  
      elsif rowset ( 1 ).description.type = dbms_tf.type_varchar2 then  
        dbms_tf.trace (   
          msg => rowset ( 1 ).tab_varchar2 ( i )  
        );  
          
        col_val := '"' || rowset ( 1 ).tab_varchar2 ( i ) || '"';   
      end if;  
  
      /* Build an array of how many times each value in the   
         pivoted column appears in the results   
      */  
      if col_vals.exists ( col_val ) then  
  
        col_vals ( col_val ) := col_vals ( col_val ) + 1;  
        dbms_tf.trace (   
          msg => ' Seen; count = ' || col_vals ( col_val )  
        );  
  
      else  
  
        col_vals ( col_val ) := 1;  
  
      end if;  
        
    end loop;  
      
  end get_pivoted_column_values;  
    
  procedure set_pivoted_column_vals (  
    col_vals column_values,   
    env      dbms_tf.env_t  
  ) is  
    col_name   varchar2(128);   
    ncol       dbms_tf.tab_number_t;  
    added_cols column_values;  
  begin  
    
    col_name := col_vals.first;  
      
    dbms_tf.trace (   
      msg => ' Referenced cols ' || env.ref_put_col.count  
    );  
      
    for cols in 1 .. env.put_columns.count loop  
      dbms_tf.trace (   
        msg => ' Setting col ' || cols || ' ' || env.put_columns ( cols ).name  
      );  
      added_cols ( env.put_columns ( cols ).name ) := cols;  
    end loop;  
      
    /* For all the values found in the pivoted column   
       See if this column exists in the output  
       If it does, set its count   
    */  
    while ( col_name is not null ) loop  
        
      if added_cols.exists ( col_name ) then  
        dbms_tf.trace (   
          msg => ' col ' || col_name || ' in output; assigning '  
        );  
          
        ncol ( 1 ) := col_vals ( col_name );  
        dbms_tf.trace (   
          msg => ' Getting col ' || col_name  
        );  
          
        dbms_tf.put_col ( added_cols ( col_name ) , ncol );      
          
      end if;  
  
      col_name := col_vals.next ( col_name );  
        
    end loop;  
      
  end set_pivoted_column_vals;  
  
  procedure fetch_rows ( col_query varchar2 ) as  
    env    dbms_tf.env_t := dbms_tf.get_env();   
    rowset dbms_tf.row_set_t;   
      
    colcnt pls_integer;   
    rowcnt pls_integer;   
      
    row_replication_factor dbms_tf.tab_naturaln_t;       
      
    col_vals column_values;  
      
  begin  
      
    dbms_tf.get_row_set (   
      rowset, rowcnt, colcnt   
    ) ;   
  
    dbms_tf.trace (   
      msg => 'Looping for ' || rowcnt || ' rows ' ||   
      colcnt || ' cols '   
    );  
      
    get_pivoted_column_values (  
      rowset                 => rowset,   
      rowcnt                 => rowcnt,   
      col_vals               => col_vals,  
      row_replication_factor => row_replication_factor  
    );  
      
    set_pivoted_column_vals (  
      col_vals => col_vals, env => env  
    );  
      
    dbms_tf.row_replication (   
      replication_factor => row_replication_factor   
    );   
      
    dbms_tf.trace (   
      env => env  
    );   
  
  end fetch_rows;  
  
end dynamic_pivot_ptf_pkg;   
/
create or replace function dynamic_pivot_ptf (  
    tab       table,    
    pivot_col columns,   
    col_query varchar2  
) return table pipelined table polymorphic using dynamic_pivot_ptf_pkg;  
/

with jobs as (  
  select job_id  
  from   hr.employees  
)  
select * from dynamic_pivot_ptf (   
  jobs   
  ,columns ( job_id )   
  ,'select distinct job_id from hr.employees'  
)
/
with sals as (  
  select salary  
  from   hr.employees  
)  
select * from dynamic_pivot_ptf (   
  sals, columns ( salary )  
  ,'select distinct salary from hr.employees where department_id in ( 100 ) '  
);
/


with compta as (
 select raise_date
 from  hr.raise_history
)
select * from dynamic_pivot_ptf (
 compta, columns (raise_date)
 ,'select distinct raise_date from hr.raise_history' 
);
/