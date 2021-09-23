-------------------------------------------------------------------------------
--
-- Script:	hex_blockdump.sql
-- Purpose:	to dump a data block in hex
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Comment:	DecimalDBA is left defined so that the next block can be dumped.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept File "File number" 1
@accept Block "Block number" 2

column DecimalDBA new_value DecimalDBA

set termout off
select
  sys.dbms_utility.make_data_block_address(&File, &Block)  DecimalDBA
from
  sys.dual
/
alter session set events '10289 trace name context forever, level 1'
/
set termout on

prompt
prompt alter session set events 'immediate trace name blockdump level &DecimalDBA'
set feedback on
alter session set events 'immediate trace name blockdump level &DecimalDBA'
/
set feedback off
alter session set events '10289 trace name context off'
/

undefine File
undefine Block

@restore_sqlplus_settings
