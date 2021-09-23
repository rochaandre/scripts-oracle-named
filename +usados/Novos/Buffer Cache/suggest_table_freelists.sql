-------------------------------------------------------------------------------
--
-- Script:	suggest_table_freelists.sql
-- Purpose:	to suggest a number of freelists for insert intensive tables
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Comment:	We only add 1.5 bytes for the row directory overhead to allow
--		for a possible rounding of the avg_row_len. So ITL space usage
--		may be overstated by as much as 1 byte per row.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set termout off
column value new_value BlkSz
column maxfree new_value MaxFree
column user new_value User

select
  value,
  decode(value,
    2048, 19,
    4096, 47,
    97
  )  maxfree,
  user
from
  sys.v_$parameter
where
  name = 'db_block_size'
/
set termout on
set verify off

@accept Owner "Owner" &User
accept TableName prompt "Table Name: "

select
  decode(avg_space, 0, null, last_analyzed)  analyzed,
  least(
    &MaxFree,
    decode(
      round(
        sqrt(
          (
            &BlkSz - 66 - avg_space -
            greatest(avg_row_len + 1.5, 11) * num_rows / blocks
          ) / 12
        )
      ),
       1,  1,
       2,  3,
       3,  7,
       4, 11,
       5, 17,
       6, 23,
       7, 29,
       8, 37,
       9, 47,
      10, 59,
      11, 67,
      12, 79,
      97
    )
  )  suggestion
from
  dba_tables
where
  owner = upper('&Owner') and
  table_name = upper('&TableName')
/

undefine BlkSz
undefine MaxFree
undefine User
@restore_sqlplus_settings
