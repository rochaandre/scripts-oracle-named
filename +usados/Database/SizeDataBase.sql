compute sum of Mb on report
break on report
col Mb form 999,999
select name, 'DataFiles', sum(df.bytes)/1024/1024 Mb
from dba_data_files df,v$database
group by name
union
select name, 'TempFiles', sum(tf.bytes)/1024/1024 Mb
from dba_temp_files tf, v$database
group by name
/