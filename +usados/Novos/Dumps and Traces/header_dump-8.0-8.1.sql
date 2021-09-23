-------------------------------------------------------------------------------
--
-- Script:	header_dump.sql
-- Purpose:	to dump a segment header block by name
-- For:		8.0 and above
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Owner "Owner" SYS
@accept SegmentName "Segment name" OBJ$

column header_file new_value File
column header_block new_value Block

set termout off
select
  header_file,
  header_block
from
  sys.dba_segments
where
  owner = upper('&Owner') and
  segment_name = upper('&SegmentName')
/
define File=&File
define Block=&Block
set termout on

prompt
prompt alter system dump datafile &File block &Block
set feedback on
alter system dump datafile &File block &Block
/

undefine Owner
undefine SegmentName
undefine File
undefine Block

@restore_sqlplus_settings
