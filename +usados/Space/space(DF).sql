select substr(df.name,1,40) "File name", lpad(to_char(df.file#),4) "File", df.bytes/1024/1024 "Size",
sum(sg.bytes/1024/1024) "Used bytes", (sum(sg.bytes) * 100) / df.bytes "% full"
from dba_extents sg, dba_data_files db, v$datafile df
where db.file_id = df.file#
and sg.tablespace_name (+) = db.tablespace_name
and sg.file_id (+) = db.file_id
group by substr(df.name,1,40), df.file#, df.bytes
/