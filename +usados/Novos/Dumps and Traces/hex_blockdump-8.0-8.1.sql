-------------------------------------------------------------------------------
--
-- Script:	hex_blockdump.sql
-- Purpose:	to dump a range of data blocks in hex
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
alter session set events '10289 trace name context forever, level 1'
/
set termout on

prompt
prompt alter system dump datafile &File block min &BlockMin block max &BlockMax
set feedback on
alter system dump datafile &File block min &BlockMin block max &BlockMax
/
set feedback off
alter session set events '10289 trace name context off'
/

undefine File
undefine BlockMin
undefine BlockMax

@restore_sqlplus_settings
