select v$session.SID, v$session.serial#
from v$session, v$circuit
where v$session.saddr = v$circuit.saddr

select 'alter system kill session '||''''||v$session.SID||','||v$session.serial#||''';'
from v$session, v$circuit
where v$session.saddr = v$circuit.saddr;
