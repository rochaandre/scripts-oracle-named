-------------------------------------------------------------------------------
--
-- Script:	next_blockdump.sql
-- Purpose:	to dump the next data block
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
set termout on

prompt
prompt alter session set events 'immediate trace name blockdump level &DecimalDBA'
set feedback on
alter session set events 'immediate trace name blockdump level &DecimalDBA'
/

@restore_sqlplus_settings
