select a.name, b.xacts,c.sid,c.serial#,c.username,d.sql_text, e.addr
from v$rollname a, v$rollstat b, v$session c, v$sqlarea d, v$transaction e
where a.usn = b.usn and
b.usn=e.xidusn
and c.taddr=e.addr
and c.sql_address = d.address and
c.sql_hash_value = d.hash_value
order by a.name,c.sid
/
