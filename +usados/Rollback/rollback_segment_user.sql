 col "Oracle Username" for a18 
 col "Rollback Segment Name" for a21 
 ttitle 'ROLLBACK SEGMENT USE' 
 select r.name "Rollback Segment Name", 
 l.sid "Oracle PID", 
 p.spid "Syst PID", 
 s.username "Oracle Username" 
 from v$lock l, v$process p, v$rollname r, v$session s 
 where l.sid = p.pid(+) and 
 s.sid = l.sid and 
 TRUNC (l.id1(+)/65536)=r.usn and 
 l.type(+) = 'TX' and 
 l.lmode(+) = 6 
 order by r.name 
 / 