create or replace function sf_add_vat (p number) return number as 
begin
  return p*1.18;
end;
/

drop table tmp purge;
create table tmp as select * from dba_tables where rownum <= 1000;
 
insert into tmp select tmp.* from tmp, (select * from dual connect by level <= 799) ;
commit;
select count(*) from tmp;

set timing on ;
select max(sf_add_vat(pct_free)) from tmp;
select max(pct_free*1.18) from tmp;

create or replace function sf_add_vat_deterministic (p number) return number  deterministic as 
begin
  return p*1.18;
end;
/

create or replace function sf_add_vat_deterministic_udf (p number) return number  deterministic as 
  pragma udf;
begin
  return p*1.18;
end;
/

declare
  s timestamp;
  
  procedure run(p_function varchar2) as
    v_result number;
  begin
    s := systimestamp;
    for i in 1..10 loop
      if p_function = 'BASE' then
        select max(sf_add_vat(pct_free)) into v_result from tmp;
      elsif p_function = 'BASE_DETERMINISTIC' then
        select max(sf_add_vat_deterministic(pct_free)) into v_result from tmp;
      elsif p_function = 'BASE_DETERMINISTIC_UDF' then
        select max(sf_add_vat_deterministic_udf(pct_free)) into v_result from tmp;
      elsif p_function = 'GO_SQL' then
        select max(pct_free*pct_free) into v_result from tmp;
      end if;
                              
    end loop;
    
    dbms_output.put_line(Rpad(P_Function,25,' ') || ': ' || ((systimestamp - s)/10));
  end;
begin
  run ('BASE');
  run ('BASE_DETERMINISTIC');
  run ('BASE_DETERMINISTIC_UDF');
  run ('GO_SQL');
end;
/

select max( (select sf_add_vat(pct_free) from dual)) from tmp;