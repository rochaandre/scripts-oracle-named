/*  Displays locks on the objects  and
also gives the SQL statement causing the lock */

spool ./log/lock_objname.log
set echo off
set feedback on
set linesize 500
col sid format 99999
col serial format 999
col username format a10
col osuser format a10
col owner format a10
col object_name format a30
col machine format a15
col program format a35
col lockmode format a10
prompt ----Sessions and objects involved in the locks

Select  distinct s.sid,s.serial#,s.username,s.status,s.osuser,p.spid "OS Pid",o.object_name, 
           decode(l.locked_mode,
                  0, 'None',
                  1, 'Null',
                  2, 'Row-S',
                  3, 'Row-X',
                  4, 'Share',
                  5, 'S/Row-X',
                  6, 'Exclusive',
                  to_char(l.locked_mode)) "LockMode",
           s.lockwait,s.program,s.taddr
from dba_objects o , v$locked_object l, v$session s,v$process p, v$sqltext t
where l.object_id=o.object_id
   and  l.session_id = s.sid
   and  s.paddr = p.addr
   and  t.address = s.sql_address
   and  t.hash_value = s.sql_hash_value
   order by sid,serial#;
   
prompt ----SQL statements sessions currently executing

Select  distinct s.sid,s.serial#,t.piece, t.sql_text
from dba_objects o , v$locked_object l, v$session s,v$process p, v$sqltext t
where l.object_id=o.object_id
   and  l.session_id = s.sid
   and  s.paddr = p.addr
   and  t.address = s.sql_address
   and  t.hash_value = s.sql_hash_value
   order by sid,serial#;
spool off