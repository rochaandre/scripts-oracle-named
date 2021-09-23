-- Counts VALID and INVALID(INVALID,DISABLED etc) objects

Set linesize 100 pagesize 60 feedback off
ttitle skip center "Status count of VALID and INVALID Objects" skip 2
col owner format a15
col object_type format a25
set numformat 9999999

clear breaks
clear computes
break on owner skip 1  on report skip 2

compute sum of count on owner 
compute sum of count on report
spool list_obj_status_count.out

select owner, object_type, status, count(*) "Count"
from dba_objects 
where owner in ('ESS','OEBS')
group by owner,object_type,status;

ttitle off
spool off




