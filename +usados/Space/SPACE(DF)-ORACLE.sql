set lines 120
set pages 100
column 'Used %' format a10
column name format a45
column tablespace format a18



SELECT 	 	
	d.file_name "Name", 
	d.tablespace_name "Tablespace", 
	TO_CHAR(NVL(d.bytes / 1024 / 1024, 0), '99999990.00') "Size (M)", 
	TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0))/1024/1024, 0),999990.00)  "Used (M)", 
	TO_CHAR(NVL((d.bytes - NVL(s.bytes, 0)) / d.bytes * 100, 0), '999990.00') "Used %" 
FROM sys.dba_data_files d, v$datafile v,
(SELECT file_id,
	SUM(bytes) bytes  FROM sys.dba_free_space  GROUP BY file_id) s WHERE (s.file_id (+)= d.file_id) AND (d.file_name = v.name)
UNION ALL 
SELECT 	
	d.file_name "Name", 
	d.tablespace_name "Tablespace", 
	TO_CHAR(NVL(d.bytes / 1024 / 1024, 0), '99999990.00') "Size (M)",
	TO_CHAR(NVL(t.bytes_cached/1024/1024, 0),99990.00) "Used (M)", 
	TO_CHAR(NVL(t.bytes_cached / d.bytes * 100, 0), '999990.00') "Used %" 
FROM sys.dba_temp_files d, v$temp_extent_pool t, v$tempfile v WHERE (t.file_id (+)= d.file_id) AND (d.file_id = v.file#)
/
