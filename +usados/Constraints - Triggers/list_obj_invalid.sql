-- Lists all objects whose status is not VALID(ie INVALID,DISABLED etc)

Set linesize 100 pagesize 60 feedback off
ttitle skip center "Status report of invalid Objects" skip 2
col owner format a15
col ObjectName format a40
set numformat 99999.9
spool C:\list_obj_invalid.out

select a.owner "Owner",
       a.object_type "ObjectType",
       a.object_name "ObjectName",  
       a.status "Status"
from   sys.dba_objects a
where  a.status != 'VALID'
order by a.owner,a.object_type,a.object_name,a.status;

ttitle off
spool off
