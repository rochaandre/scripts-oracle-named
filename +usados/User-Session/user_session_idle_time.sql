column sid format 999 
column last format a22 heading "Last non-idle time" 
column curr format a22 heading "Current time" 
column secs format 99999999.999 heading "idle-time |(seconds)" 
column mins format 999999.99999 heading "idle-time |(minutes)" 

select sid, to_char((sysdate - (hsecs - value)/(100*60*60*24)), 
'dd-mon-yy hh:mi:ss') last, to_char(sysdate, 'dd-mon-yy hh:mi:ss') curr, 
(hsecs - value)/(100) secs, (hsecs - value)/(100*60) mins 
from v$timer, v$sesstat 
where statistic# = (select statistic# from v$statname 
where name = 'process last non-idle time'); 

