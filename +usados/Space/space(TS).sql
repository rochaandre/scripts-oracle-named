rem   #####################################################################################
rem   #                                                                                   #
rem   # Name.............: space.sql                                                      #
rem   #                                                                                   #
rem   # Purpose..........: Generate Tablespace space report                               #
rem   #                                                                                   #
rem   # For..............: 8.1.x and 9.x                                                  #
rem   #                                                                                   #
rem   # Author...........: Sérgio Augusto Goulart                                         # 
rem   #                                                                                   #
rem   # Created..........: 23/05/2002                                                     #
rem   #                                                                                   #  
rem   #####################################################################################


set lines 100
set pages 100

select a.tablespace_name Tablespace, 
       to_char(nvl(d.bytes,0) / 1024 / 1024,'999,999,999.999') "Size (MB)",
       to_char(nvl(f.bytes,0) / 1024 / 1024,'999,999,999.999') "Free (MB)",
       to_char((nvl(d.bytes,0) - nvl(f.bytes,0)) / 1024 / 1024,'999,999,999.999') "Used (MB)",
       to_char(((nvl(d.bytes,0) - nvl(f.bytes,0))/nvl(d.bytes,0))*100,'9999.99') "Used (%)"
from dba_tablespaces a,
     (select tablespace_name tablespace_name, sum(bytes) bytes from dba_data_files group by tablespace_name) d,
     (select tablespace_name tablespace_name, sum(bytes) bytes from dba_free_space group by tablespace_name) f
where a.tablespace_name = d.tablespace_name(+) 
  and a.tablespace_name = f.tablespace_name(+)
  AND NOT (a.extent_management LIKE 'LOCAL' AND a.contents LIKE 'TEMPORARY')
UNION ALL
select a.tablespace_name Tablespace, 
       to_char(nvl(d.bytes,0) / 1024 / 1024,'999,999,999.999') "Size (MB)",
       to_char(nvl(f.bytes,0) / 1024 / 1024,'999,999,999.999') "Free (MB)",
       to_char((nvl(d.bytes,0) - nvl(f.bytes,0)) / 1024 / 1024,'999,999,999.999') "Used (MB)",
       to_char(((nvl(d.bytes,0) - nvl(f.bytes,0))/nvl(d.bytes,0))*100,'9999.99') "Used (%)"
from dba_tablespaces a,
     (select tablespace_name tablespace_name, sum(bytes) bytes from dba_temp_files group by tablespace_name) d,
     (select tablespace_name tablespace_name, sum(bytes_cached) bytes from v$temp_extent_pool group by tablespace_name) f
where a.tablespace_name = d.tablespace_name(+) 
  and a.tablespace_name = f.tablespace_name(+)
  and a.extent_management like 'LOCAL'
  and a.contents like 'TEMPORARY'
/