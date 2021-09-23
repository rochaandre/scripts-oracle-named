--Program Name: idx_size_proc.sql 
--Purpose:  Creates procedures to calculate index size
--Usage: SQL>@idx_size_proc.sql
-- Program: Idx_size_proc
-- Purpose: Gives total index size for given index
-- Input: block size,pctfree,index_name,number of entries
-- Notes: set serveroutput on
--        avg_row_length includes index overhead of 10 bytes(index_header(8)+other_overhead(2))
--        block_overhead: 161 bytes
--        requires access to dba_tables
--        Gives size only if there are entries in the index


create or replace procedure idx_size(blok_size number,pctfre number,indx_name varchar2,num_entries number) as
t_index_name varchar2(30) default 'X';
t_table_name varchar2(30) default null;
t_table_owner varchar2(30) default null;
col_list varchar2(1000);
t_str varchar2(2000);
t_ret  number;
num_cols  number default 0;
indx_row_size  number;

avail_block_space number;
pctfreespace number;
avail_data_space number;
rows_per_block number; 
blocks_per_index number;
bytes_per_index varchar2(50);

Cursor c1 is 
select table_owner,table_name,index_name,'avg(nvl(vsize('||column_name||'),0))' col_size 
from dba_ind_columns
where index_name = indx_name
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
           -- if t_ret is null, index does not have any entries
           bytes_per_index := '--no entries--';
      else
           -- add index overhead
           indx_row_size:=t_ret+10+num_cols;
           avail_block_space:=blok_size-161;
           pctfreespace:=avail_block_space*(pctfre/100);
           avail_data_space:=avail_block_space-pctfreespace;
           rows_per_block:=avail_data_space/indx_row_size;
           blocks_per_index:=num_entries/rows_per_block;
           bytes_per_index:=round(blocks_per_index*blok_size);
      end if;
       dbms_output.put_line(t_index_name||'   '|| bytes_per_index);
End;
/
