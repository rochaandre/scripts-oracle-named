REM findext.sql REM 
REM This script prompts user for a datafile ID number, and  
REM then lists all the segments contained in that datafile, 
REM the blockid where it starts, and how many blocks the 
REM segment contains.  It shows the owner, segment name, and 
REM segment type. 
REM 
REM Janet Robinson Stern April 2, 1997 
REM   variation on Cary  Millsap's script 
REM  

SET ECHO OFF 
ttitle -   
   center  'Segment Extent Summary' skip 2  

col ownr format a8      heading 'Owner'        justify c 
col type format a8      heading 'Type'         justify c trunc 
col name format a28     heading 'Segment Name' justify c 
col exid format     990 heading 'Extent#'      justify c 
col fiid format    9990 heading 'File#'        justify c 
col blid format   99990 heading 'Block#'       justify c 
col blks format 999,990 heading 'Blocks'       justify c  

select   
   owner         ownr,   
   segment_name  name,   
   segment_type  type,   
   extent_id     exid,   
   file_id       fiid,   
   block_id      blid,   
   blocks        blks 
from   
   dba_extents 
where  
   file_id = &file_id 
order by   
   block_id 
/ 