SELECT   b.tablespace, b.segfile#, b.segblk#, b.blocks, a.sid, a.serial#,
           a.username
  FROM     v$session a,v$sort_usage b
  WHERE    a.saddr = b.session_addr
  ORDER BY b.tablespace, b.segfile#, b.segblk#, b.blocks
/
