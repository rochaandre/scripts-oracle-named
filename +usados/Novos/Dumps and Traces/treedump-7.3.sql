-------------------------------------------------------------------------------
--
-- Script:	treedump.sql
-- Purpose:	to dump an index tree
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Owner "Owner" SYS
@accept IndexName "Segment name" OBJ$

column DecimalDBA new_value DecimalDBA

set termout off
select
  sys.dbms_utility.make_data_block_address(
    header_file,
    header_block + 1 + freelist_groups
  )
    DecimalDBA
from
  sys.dba_segments
where
  s.owner = upper('&Owner') and
  s.segment_name = upper('&IndexName')
/
set termout on

prompt
prompt alter session set events 'immediate trace name treedump level &DecimalDBA'
set feedback on
alter session set events 'immediate trace name treedump level &DecimalDBA'
/

undefine Owner
undefine IndexName

@restore_sqlplus_settings
