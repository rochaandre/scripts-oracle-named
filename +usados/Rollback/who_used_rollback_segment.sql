select /*+ RULE */
       rn.usn "number",
       rn.name "name",
       sess.schemaname "User",
       o.name "Table Name",
       rs.extents,
       rs.writes,
       rs.rssize,
       rs.hwmsize,
       rs.wraps    
from
       v$rollstat rs,
       v$rollname rn,
       v$session sess,
       sys.obj$ o,
       v$lock lck1,
       v$transaction t
where
       sess.taddr = t.addr
and    lck1.sid = sess.sid
and    lck1.id1 = o.obj#
and    lck1.type = 'TM'
and    t.xidusn = rn.usn
and    rs.usn = rn.usn 
/
