-- Gets all active sessions
-- You can restrict to users connected thru sqlplus(program like '%sqlplus%)


set linesize 100
col program format a15
col username format a10
col osuser format a10

select p.spid "pid", s.username,s.osuser,s.status,s.program
from v$session s, v$process p
where s.status like 'ACTIVE' 
  and p.addr=s.paddr;
