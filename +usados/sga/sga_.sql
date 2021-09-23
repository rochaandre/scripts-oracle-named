-- SGA performance Statistics

--Library Cache miss ratio(reloads/pins)% Should be (<1)
--Dictionary Cahce miss ratio(getmisses/gets)% Should be(10->15)%
--Buffer Cache miss ratio(Phy_reads/gets)% Should be(30->40)%

set serveroutput on
set feedback off linesize 120

declare
lib_cache  number :=null;
dict_cache number := null;
buf_cache number := null;
begin

select round((sum(reloads)/sum(pins+reloads))*100,3) into lib_cache
from v$librarycache;

select round((sum(getmisses)/sum(gets+getmisses))*100,3) into dict_cache
from v$rowcache;

select round((a.value/(b.value+c.value))*100,3) into buf_cache
from v$sysstat a,v$sysstat b,v$sysstat c
where a.name = 'physical reads' and
      b.name = 'db block gets' and
      c.name = 'consistent gets';

dbms_output.put_line('-------SGA Statistics --------   ');

dbms_output.put_line('Library miss(<1%)    Dictionary miss(10->15)%    Buffer miss(30->40)%    ');
dbms_output.put_line('-------------------------------------------------------------------');
dbms_output.put_line(lpad(lib_cache,25)||lpad(dict_cache,35)||lpad(buf_cache,20));

end;
/

