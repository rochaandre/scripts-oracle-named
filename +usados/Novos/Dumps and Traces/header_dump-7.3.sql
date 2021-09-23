-------------------------------------------------------------------------------
--
-- Script:	header_dump.sql
-- Purpose:	to dump a segment header block by name
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Comment:	DecimalDBA is left defined so that the next block can be dumped.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Owner "Owner" SYS
@accept SegmentName "Segment name" OBJ$

column DecimalDBA new_value DecimalDBA

set termout off
select
  sys.dbms_utility.make_data_block_address(header_file, header_block)
    DecimalDBA
from
  sys.dba_segments
where
  owner = upper('&Owner') and
  segment_name = upper('&SegmentName')
/
set termout on

prompt
prompt alter session set events 'immediate trace name blockdump level &DecimalDBA'
set feedback on
alter session set events 'immediate trace name blockdump level &DecimalDBA'
/

undefine Owner
undefine SegmentName

@restore_sqlplus_settings
