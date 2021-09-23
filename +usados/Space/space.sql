----------------------------------------------
-- list tablespace Usage,MaxFree,Fragment
-- author: kerlion he
-- location:beijing,china
-- date: 15-may-2002
----------------------------------------------
set pagesize 80
set linesize 80
col tablespace_name for a18
COL total for 999,999 heading "MB|Total"
COL free for 999,999 heading "MB|Free"
COL max_free for 999,999 heading "MB|Extent|MaxFree"
col used_pct for 990.99 heading "Used|percnt"
col free_cnt for 9999 heading "Free|Extent|Count"
select a.tablespace_name,
round(100-b.free/a.total*100,2) Used_pct,
a.total,
b.free,
b.max_free,
b.free_cnt
from
(select tablespace_name,
sum(bytes)/1024/1024 total
from dba_data_files
group by tablespace_name
) a,
(select tablespace_name,
sum(bytes)/1024/1024 free,
max(bytes)/1024/1024 max_free,
count(bytes) free_cnt
from dba_free_space
group by tablespace_name
) b
where a.tablespace_name=b.tablespace_name ;

-- se ha elevação na contagem livre da extensão, altere então o
-- &ts_name do tablespace coalesce;

-- se ainda altamente na extensão livre, você necessitar
-- exp/imp ou
-- altere o ts_name do tablespace do movimento do tb_name da tabela
-- ou
-- altere o ts_name do tablespace da reconstrucção do idx_name do
-- índice

set serveroutput on size 20000
set linesize 80

declare
cursor c_map(p_file_id number) is
(select file_id,block_id,blocks,'X' used
from dba_extents where file_id=p_file_id
union
select file_id,block_id,blocks,'=' used
from dba_free_space where file_id=p_file_id
) order by 1,2,3;
cursor c_file is
select file_name,file_id,blocks/400 bsize from dba_data_files;
j number :=1;
begin
for r_file in c_file
loop
dbms_output.put_line('Map of '||r_file.file_name);
for r_map in c_map(r_file.file_id)
loop
for i in 1..r_map.blocks/r_file.bsize
loop
dbms_output.put(R_MAP.USED);
if j>=80 then
j :=1;dbms_output.new_line;
else
j := j+1;
end if;
end loop;
end loop;
dbms_output.new_line;j:=1;
end loop;
end;
/

----------------------------------------------
-- display detail map of special datafile
-- author: kerlion he
-- location:beijing,china
-- date: 10-Mar-2002
----------------------------------------------

set serveroutput on size 2500
set linesize 80
set verify off


declare
v_file_id number :=&p_file_id;
cursor c_map is
(select file_id,block_id,blocks,'X' used
from dba_extents where file_id=v_file_id
union
select file_id,block_id,blocks,'=' used
from dba_free_space where file_id=v_file_id
) order by 1,2,3;
j number :=1;
bsize number;
begin
select blocks/(80*25) into bsize from dba_data_files where file_id=v_file_id;
--that is display in 80 lines with linesize of 80 
for r_map in c_map
loop
for i in 1..r_map.blocks/bsize
loop
dbms_output.put(R_MAP.USED);
if j>=80 then
j :=1;dbms_output.new_line;
else
j := j+1;
end if;
end loop;
end loop;
end;
/
