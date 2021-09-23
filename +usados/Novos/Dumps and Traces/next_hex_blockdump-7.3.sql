-------------------------------------------------------------------------------
--
-- Script:	next_hex_blockdump.sql
-- Purpose:	to dump the next data block in hex
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Comment:	DecimalDBA must be set
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column DecimalDBA new_value DecimalDBA

set termout off
select
  &DecimalDBA + 1  DecimalDBA
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

@restore_sqlplus_settings
