-------------------------------------------------------------------------------
--
-- Script:	buffer_busy_waits.sql
-- Purpose:	to report the block classes and tablespace affect by bbwaits
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column block_class format a30
column buffer_pool format a30

select
  w.class  block_class,
  w.count  total_waits,
  w.time  time_waited
from
  sys.v_$waitstat  w
where
  w.count > 0
order by 3 desc
/
select
  d.tablespace_name,
  sum(x.count)  total_waits,
  sum(x.time)  time_waited
from
  sys.x_$kcbfwait  x,
  sys.dba_data_files  d
where
  x.count > 0 and
  x.indx + 1 = d.file_id
group by
  d.tablespace_name
order by 3 desc
/

@restore_sqlplus_settings
