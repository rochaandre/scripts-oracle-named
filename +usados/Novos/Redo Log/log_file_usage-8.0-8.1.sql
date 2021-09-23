-------------------------------------------------------------------------------
--
-- Script:	log_file_usage.sql
-- Purpose:	to see how much of the current log file has been used
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column used justify right

alter system checkpoint
/

select
  le.leseq  log_sequence#,
  substr(to_char(100 * cp.cpodr_bno / le.lesiz, '999.00'), 2) || '%'  used
from
  sys.x_$kcccp  cp,
  sys.x_$kccle  le
where
  le.inst_id = userenv('Instance') and
  cp.inst_id = userenv('Instance') and
  le.leseq = cp.cpodr_seq
/

@restore_sqlplus_settings
