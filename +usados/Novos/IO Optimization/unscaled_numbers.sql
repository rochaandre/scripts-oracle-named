-------------------------------------------------------------------------------
--
-- Script:	unscaled_numbers.sql
-- Purpose:	to find NUMBER columns with no scale and lots of digits
-- For:		8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  owner,
  table_name,
  column_name,
  avg_col_len
from
  dba_tab_columns
where
  data_type = 'NUMBER' and
  data_scale is null and
  avg_col_len > 9
/

@restore_sqlplus_settings
