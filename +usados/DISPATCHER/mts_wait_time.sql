REM NAME: mts_wait_time.sql 
REM USAGE:"@path/mts_wait_time" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    select on v$queue.
REM ------------------------------------------------------------------------ 
REM AUTHOR:  
REM    Ken Bahadur            
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    Generate Average wait time report for dispatchers
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It is NOT  
REM    supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always run new scripts on a test instance initially. 
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 

COLUMN awt FORMAT A30 HEADING 'Average Wait Time per Request'
SELECT DECODE (
          totalq,
          0, 'No Requests',
           (wait / totalq) * 100 || 'Seconds Request Wait'
       ) awt
  FROM v$queue
 WHERE type = 'COMMON';
