set linesize 100;
break on report;
column size format 99,999,999,999
column "Used Bytes" format 99,999,999,999;
column "% full" format 999;
compute sum of Size on report;
compute sum of "Used bytes" on report;
select substr(df.name,1,40) "File name", lpad(to_char(df.file#),4) "File", df.bytes "Size",
sum(sg.bytes) "Used bytes", (sum(sg.bytes) * 100) / df.bytes "% full"
from dba_extents sg, dba_data_files db, v$datafile df
where db.file_id = df.file#
and sg.tablespace_name (+) = db.tablespace_name
and sg.file_id (+) = db.file_id
group by substr(df.name,1,40), df.file#, df.bytes;
-- (end of "filesize.sql")

-- freespac.sql
column file_id format 99999 heading "File#";
column Extents format 9999999;
column Bytes format 99,999,999,999;
column Blocks format 999,999,999;
column Largest format 9,999,999,999;
to "temporary" tablespaces
select substr(tablespace_name,1,16) "Tablespace",
file_id, count(block_id) "Extents",
sum(blocks) "Blocks", sum(bytes) "Bytes", max(bytes) "Largest"
from user_free_space
group by tablespace_name, file_id
union
select substr(tablespace_name,1,16) "Tablespace",
file_id, 1 "Extents", blocks_free "Blocks", bytes_free "Bytes",
bytes_free "Largest"
from v$temp_space_header
order by 1;
-- (end of "freespac.sql") 
