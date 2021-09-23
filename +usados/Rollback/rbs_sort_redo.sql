-- Performance statistics for Sort, RBS, and redo logs

--Sorts (disk/memory)% Should be (<10%)
--Rbs Wait (waits/gets)% Should be(<1%)
--Redo buffer waits()% Should be nearly zero%


set serveroutput on
set feedback off

declare
logical_reads number := null;
disk_sorts  number :=null;
rbs_waits number := null;
fl_waits number := null;
redo_reqs number := null;
begin

select sum(a.value) into logical_reads
from v$sysstat a
where a.name  in ('db block gets','consistent gets');

select round((d.value/(d.value+m.value))*100,3) into disk_sorts
from v$sysstat d, v$sysstat m
where d.name = 'sorts (disk)'
  and m.name = 'sorts (memory)';

select round((sum(waits)/sum(gets+waits))*100,3) into rbs_waits
from v$rollstat s, v$rollname n
where s.usn = n.usn;

select round((count/logical_reads)*100,3) into fl_waits
from v$waitstat
where class ='free list';

select a.value into redo_reqs
from v$sysstat a
where a.name  in ('redo log space requests');

dbms_output.put_line('RbsWait%(<1)       DiskSort%(<10)      FreeListWait%(<1)      #RedoSpaceReq');
dbms_output.put_line('----------------------------------------------------------------------------');
dbms_output.put_line(lpad(rbs_waits,15)||lpad(disk_sorts,20)||lpad(fl_waits,20)||lpad(redo_reqs,20));

end;
/


