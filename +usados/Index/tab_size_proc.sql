--Program Name: tab_size_proc.sql 
--Purpose: Creates stored procedure to calculate table size
--Usage: SQL>@tab_size_proc.sql
-- Input: block size,pctfree,table_name,number of rows
-- Notes: set serveroutput on
--        avg_row_length includes row overhead 
--        block_overhead= 90 bytes
--        requires access to dba_tables
--        Gives size only if there are test entries in the table


create or replace procedure table_size(blok_size number,pctfre number,tab_name varchar2,nr_rows number) 
as
table_row_len varchar2(50);
t_table_name varchar2(30) default null;

table_row_size number;
avail_block_space number;
pctfreespace number;
avail_data_space number;
rows_per_block number; 
blocks_per_table number;
bytes_per_table varchar2(50);

Begin
 dbms_output.enable(10000000);
select table_name,avg_row_len into t_table_name, table_row_len
from dba_tables
where table_name=tab_name;

     if table_row_len is null then
           -- if row lenght is null, table does not have any rows
           bytes_per_table := '--no rows--';
      else
           table_row_size:=table_row_len;
           avail_block_space:=blok_size-90;
           pctfreespace:=avail_block_space*(pctfre/100);
           avail_data_space:=avail_block_space-pctfreespace;
           rows_per_block:=avail_data_space/table_row_size;
           blocks_per_table:=nr_rows/rows_per_block;
           bytes_per_table:=round(blocks_per_table*blok_size);
      end if;
      dbms_output.put_line(t_table_name||'   '|| bytes_per_table);
End;
/
