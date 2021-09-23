REM NAME: mts_response.sql 
REM USAGE:"@path/mts_response" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    select on v$queue and v$dispatcher and must be running MTS.
REM ------------------------------------------------------------------------ 
REM AUTHOR:  
REM    Ken Bahadur            
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM  Show average wait time for MTS.    
REM    
REM ------------------------------------------------------------------------ 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It 
REM    is NOT supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always initially run new scripts on a test instance.  
REM ------------------------------------------------------------------------ 
REM Main text of the script follows: 
 
SET PAGES 2000
COLUMN protocol                                 format a10
COLUMN "Average Wait Time per Response"         format a40
REM
SELECT network "Protocol",
       DECODE (
          SUM (totalq),
          0, 'No Responses',
          SUM (wait) / SUM (totalq) || ' hundredths of seconds'
       ) "Average Wait Time per Response"
  FROM v$queue q, v$dispatcher d
 WHERE q.type = 'DISPATCHER'
   AND q.paddr = d.paddr
 GROUP BY network
/

CLEAR columns
