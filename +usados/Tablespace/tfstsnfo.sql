SET ECHO off 
REM NAME:   TFSTSNFO.SQL 
REM USAGE:"@path/tfstsnfo" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM SELECT on DBA_FREE_SPACE, DBA_DATA_FILES, DBA_SEGMENTS, DBA_EXTENTS 
REM ------------------------------------------------------------------------ 
REM AUTHOR:  
REM    Ottar Sorland of Oracle UK      
REM    Copyright Oracle Corporation   
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    This script displays information about space in tablespaces,  
REM fragmentation and potential extent-problems. It has three sections: 
REM 
REM    1. Space available per tablespace.   
REM       Shows total size in bytes, total free space in bytes,   
REM       percentage free space to total space,  
REM       the size of the largest contiguous free segment and   
REM      
REM    2. Lists tables and indexes with more than 20 extents.  
REM       
REM    3. Lists tables/indexes whose next extent will not fit  
REM   
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It is NOT  
REM    supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always run new scripts on a test instance initially. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
set pagesize 300  
       
column sumb format 999,999,999  
column extents format 9999  
column bytes format 999,999,999  
column largest format 999,999,999  
column Tot_Size format 999,999,999  
column Tot_Free format 999,999,999  
column Pct_Free format 999,999,999  
column Chunks_Free format 999,999,999   
column Max_Free format 999,999,999  
set echo off  
spool TFSTSNFO.SQL  
       
PROMPT  SPACE AVAILABLE IN TABLESPACES   
       
select a.tablespace_name,sum(a.tots) Tot_Size,   
sum(a.sumb) Tot_Free,  
sum(a.sumb)*100/sum(a.tots) Pct_Free,   
sum(a.largest) Max_Free,sum(a.chunks) Chunks_Free   
from   
(  
select tablespace_name,0 tots,sum(bytes) sumb,   
max(bytes) largest,count(*) chunks  
from dba_free_space a  
group by tablespace_name  
union  
select tablespace_name,sum(bytes) tots,0,0,0 from  
dba_data_files  
group by tablespace_name) a  
group by a.tablespace_name;  
       
column owner format a15  
column segment_name format a30  
       
       
PROMPT   SEGMENTS WITH MORE THAN 20 EXTENTS   
       
select owner,segment_name,extents,bytes ,   
max_extents,next_extent   
from  dba_segments   
where segment_type in ('TABLE','INDEX') and extents>20   
order by owner,segment_name;  
       
       
       
PROMPT SEGMENTS WHERE THERE'S NOT ENOUGH ROOM FOR THE NEXT EXTENT   

       
select  a.owner, a.segment_name, b.tablespace_name,  
     decode(ext.extents,1,b.next_extent,  
     a.bytes*(1+b.pct_increase/100)) nextext,   
     freesp.largest  
from    dba_extents a,  
     dba_segments b,  
     (select owner, segment_name, max(extent_id) extent_id,  
     count(*) extents   
     from dba_extents   
     group by owner, segment_name  
     ) ext,  
     (select tablespace_name, max(bytes) largest  
     from dba_free_space   
     group by tablespace_name  
     ) freesp  
where   a.owner=b.owner and  
     a.segment_name=b.segment_name and  
     a.owner=ext.owner and   
     a.segment_name=ext.segment_name and  
     a.extent_id=ext.extent_id and  
     b.tablespace_name = freesp.tablespace_name and   
     decode(ext.extents,1,b.next_extent,  
     a.bytes*(1+b.pct_increase/100)) > freesp.largest  
/  
spool off  
