--Program Name: idx_row_len.sql 
-- Purpose: Displays avg index row length for all the indexes
--Usage: SQL>@idx_row_len.sql
-- Input: none
-- Notes: set serveroutput on
--        avg_row_length includes index overhead of 10 bytes(index_header(8)+other_overhead(2))
--        requires access to dba_tables
--   If the index does not have any entries it returns null. This procedure
--   to calculate index size works only when you have the test data in the 
--   database
-- VSIZE doesn't work for CLOB columns

Declare
t_index_name varchar2(30) default 'X';
t_table_name varchar2(30) default null;
t_table_owner varchar2(30) default null;
col_list varchar2(1000);
t_str varchar2(2000);
t_ret  number;
num_cols  number default 0;
indx_row_size  varchar2(50);

Cursor c1 is 
select table_owner,table_name,index_name,'avg(nvl(vsize('||column_name||'),0))' col_size 
from dba_ind_columns
where index_owner not in ('SYS','SYSTEM')
order by table_name,index_name;
Begin
dbms_output.enable(10000000);
for i in c1 loop
  if t_index_name = i.index_name then
    col_list:=col_list||'+';
  end if;

  If t_index_name != i.index_name and t_index_name != 'X' then
  t_str := 'select round('||col_list||') from '||t_table_owner||'.'||t_table_name;
        EXECUTE IMMEDIATE t_str INTO t_ret;
        if t_ret is null then
           -- if t_ret is null, index does not have any entries
           indx_row_size:='--no entries--';
        else
           -- add index overhead
           indx_row_size:=t_ret+10+num_cols;
        end if;
	dbms_output.put_line(t_index_name||'   '|| indx_row_size);
  end if;

  If t_index_name != i.index_name then
    col_list:=null;
    num_cols:=0;
    t_index_name:=i.index_name;
    t_table_name:=i.table_name;
    t_table_owner:=i.table_owner;
  end if;

  col_list:=col_list||i.col_size;
  num_cols:=num_cols+1;
end loop;

      t_str := 'select round('||col_list||') from '||t_table_owner||'.'||t_table_name;
      EXECUTE IMMEDIATE t_str INTO t_ret;
      if t_ret is null then
         indx_row_size:='--no entries--';
      else
         indx_row_size:=t_ret+10+num_cols;
      end if;
      dbms_output.put_line(t_index_name||'   '|| indx_row_size);
End;
/
