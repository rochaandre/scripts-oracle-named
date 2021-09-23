SET ECHO off 
REM NAME:    TFSXTREP.SQL 
REM USAGE:"@path/tfsxtrep" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    SELECT on DBA_FREE_SPACE, SYS.FET$ 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM     The following script will provide a detailed report on free  
REM    extents in the database including exact sizes for all extents  
REM    above a given size and a count and total size of extents smaller 
REM    than the given size. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
SET ECHO OFF 
set newpage 0 
ttitle center 'Large Free Extents in the Database' - 
right 'Page:' format 999 sql.pno skip skip 
set feedback off 
column ta format a30 heading 'Tablespace Name' 
column tb format a30 noprint  
column cnt format 999,999,999 heading 'No of Extents' 
column K format 999,999,999 heading 'Size K' 
break on ta  on tb skip 2 
compute sum of K on tb 
accept min_K prompt 'Minimum Extent Size to Print in K [default=100] ' 
set verify off 
spool tfsxtrep.lst 
 
 
btitle off 
column nline newline 
set pagesize 54 
set linesize 78 
set heading off 
set embedded off 
set verify off 
accept report_comment char prompt 'Enter a comment to identify system: ' 
select 'Date -  '||to_char(sysdate,'Day Ddth Month YYYY     HH24:MI:SS'), 
	'At            -  '||'&&report_comment' nline, 
	'Username      -  '||USER  nline 
from sys.dual 
/ 
prompt 
set embedded on 
set heading on 
 
 
set heading off 
select 'Minimum Sized Extent to Print = '|| 
	to_char(decode('&&min_K',null,100,to_number('&&min_K')))||' K' 
from sys.dual 
/ 
set feedback 6 
set heading on 
select tablespace_name ta, 
       tablespace_name tb, 
       bytes/1024 K 
from dba_free_space  
where bytes > decode('&&min_K',null,100,to_number('&&min_K'))*1024 
order by tablespace_name,bytes desc 
/ 
set heading off 
ttitle center 'Count of Small Free Extents in the database' - 
right 'Page:' format 999 sql.pno skip skip 
set embedded off 
select 'Count of Extents less than '|| 
        to_char(decode('&&min_K',null,100,to_number('&&min_K')))||' K' 
from sys.dual 
/ 
set embedded on 
set heading on 
clear computes 
select tablespace_name ta, 
       tablespace_name tb, 
       count(*) cnt, 
       sum(bytes/1024) K 
from dba_free_space 
where bytes < decode('&&min_K',null,100,to_number('&&min_K')) * 1024 
group by tablespace_name 
/ 
column na format a40 
column nu format 999,999 
set heading off 
set embedded on 
select 	'Total free extents is ' na, 
	count(*)  nu 
from 	sys.fet$ 
/ 
prompt End of Report 
spool off 
set embedded off 
set heading on 
clear breaks 
clear columns 
clear computes 
set verify on 
 
 
