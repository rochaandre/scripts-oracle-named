/*

Abstract  
This report provides information to assist in tuning the various buffers within the system global area (SGA) 
 
Product Name, Product Version Oracle Server - Enterprise Edition7.3.4 - 9.2.X 
Platform  Platform Independent 
Date Created  05-Nov-2002 
 
Instructions  
Execution Environment:
     <SQL, SQL*Plus, iSQL*Plus>

Access Privileges:
     Requires SELECT on V$ tables

Usage:
     sqlplus <user>/<pw> @[SCRIPTFILE] 


PROOFREAD THIS SCRIPT BEFORE USING IT! Due to differences in the way text 
editors, e-mail packages, and operating systems handle text formatting (spaces, 
tabs, and carriage returns), this script may not be in an executable state
when you first receive it. Check over the script to ensure that errors of
this type are corrected.The script will produce an output file named [outputfile].
This file can be viewed in a browser or uploaded for support analysis.
 
 
Description  
General guidelines and definitions are as follows:

  Data Block Cache              - > .90 < .97 
                                Increase the instance parameter
                                DB_BLOCK_BUFFERS to increase hit ratio.
  Shared Pool
        - Shared SQL Buffers (Library Cache)
          - Cache Hit Ratio     - > .85 
                                Highly application dependent, increase
                                the instance parameter SHARED_POOL_SIZE 
                                to increase hit ratio.
          - Avg. Users Per Stmt.  - The average number of users who execute
                                a SQL statement.                        
          - Avg. Executes Per Stmt.
                              - The average number of times that each 
                                statement gets executed.

        - Data Dictionary Cache Hit Ratio
                                - > .95 - Increase the instance parameter
                                SHARED_POOL_SIZE to increase hit ratio.
 
 
References  
Note:106285.1 - TROUBLESHOOTING GUIDE: Common Performance Tuning Issues
Note:62161.1 - Systemwide Tuning using UTLESTAT Reports in Oracle7/8
 
*/

ttitle -
  center  'SGA Cache Hit Ratios' skip 2

set pagesize 60
set heading off
set termout off

col lib_hit     format        999.999 justify right
col dict_hit    format  999.9999 justify right
col db_hit_ratio      format        999.999 justify right
col ss_share_mem  format      999.99  justify right
col ss_persit_mem format      999.99  justify right
col ss_avg_users_cursor format 999.99 justify right
col ss_avg_stmt_exe     format 999.99 justify right

col val2 new_val lib noprint
select 1-(sum(reloads)/sum(pins)) val2
from   v$librarycache
/
col val2 new_val dict noprint
select 1-(sum(getmisses)/sum(gets)) val2
from   v$rowcache
/
col val2 new_val phys_reads noprint
select value val2
from   v$sysstat
where  name = 'physical reads'
/
col val2 new_val log1_reads noprint
select value val2
from   v$sysstat
where  name = 'db block gets'
/
col val2 new_val log2_reads noprint
select value val2
from   v$sysstat
where  name = 'consistent gets'
/
col val2 new_val chr noprint
select 1-(&phys_reads / (&log1_reads + &log2_reads)) val2
from   dual
/

col val2 new_val avg_users_cursor noprint
col val3 new_val avg_stmts_exe    noprint
select sum(users_opening)/count(*) val2,
       sum(executions)/count(*)    val3
from   v$sqlarea
/

set termout on
set heading off

select  'Data Block Buffer Hit Ratio : '||&chr db_hit_ratio,
        'Shared SQL Pool                        ',
        '  Dictionary Hit Ratio      : '||&dict dict_hit,
        '  Shared SQL Buffers (Library Cache)                        ',
     '    Cache Hit Ratio         : '||&lib lib_hit,
        '    Avg. Users/Stmt   : '||
          &avg_users_cursor||'         ',
        '    Avg. Executes/Stmt      : '||
          &avg_stmts_exe||'            '
from    dual
/
