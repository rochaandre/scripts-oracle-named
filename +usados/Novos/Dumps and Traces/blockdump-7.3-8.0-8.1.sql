-------------------------------------------------------------------------------
--
-- Script:	blockdump.sql
-- Purpose:	to dump a range of data blocks
-- For:		8.0 and above
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept File "File number or 'pathname'" 1
@accept BlockMin "First block number" 2
@accept BlockMax "Last block number" &BlockMin

set termout off
alter session set max_dump_file_size = unlimited
/
set termout on

prompt
prompt alter system dump datafile &File block min &BlockMin block max &BlockMax
set feedback on
alter system dump datafile &File block min &BlockMin block max &BlockMax
/

undefine File
undefine BlockMin
undefine BlockMax

@restore_sqlplus_settings
