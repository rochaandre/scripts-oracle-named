REM Copyright (C) Think Forward.com 1998- 2004. All rights reserved. 
col host_name form a10 heading "Host"
col instance_name form a8 heading "Instance" newline
col stime form a40 Heading "Database Started At" newline
col uptime form a60 heading "Uptime" newline
set heading off

select 'Hostname      : ' || host_name
      ,'Instance Name : ' || instance_name
      ,'Started At    : ' || to_char(startup_time,'DD-MON-YYYY HH24:MI:SS') stime
      ,'Uptime        : ' || floor(sysdate - startup_time) || ' days(s) ' ||
       trunc( 24*((sysdate-startup_time) - 
       trunc(sysdate-startup_time))) || ' hour(s) ' ||
       mod(trunc(1440*((sysdate-startup_time) - 
       trunc(sysdate-startup_time))), 60) ||' minute(s) ' ||
       mod(trunc(86400*((sysdate-startup_time) - 
       trunc(sysdate-startup_time))), 60) ||' seconds' uptime
from v$instance
/