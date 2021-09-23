-------------------------------------------------------------------------------
--
-- Script:	treedump.sql
-- Purpose:	to dump an index tree
-- For:		8.0 and above
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Owner "Owner" SYS
@accept IndexName "Index name" I_OBJ1

column object_id new_value ObjectId

set termout off
select
  object_id
from
  sys.dba_objects
where
  owner = upper('&Owner') and
  object_name = upper('&IndexName')
/
set termout on

prompt
prompt alter session set events 'immediate trace name treedump level &ObjectId'
set feedback on
alter session set events 'immediate trace name treedump level &ObjectId'
/

undefine Owner
undefine IndexName
undefine ObjectId

@restore_sqlplus_settings
