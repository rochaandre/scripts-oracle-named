select v$session.SID,
       v$session.serial#,
       v$session.status,
       V$session.username,
       v$session.osuser,
       to_char(v$session.logon_time,'dd/mm/yyyy - hh24:mi:ss')
from v$session, v$circuit
where v$session.saddr = v$circuit.saddr
and v$session.status = 'KILLED'
order by 6 desc;