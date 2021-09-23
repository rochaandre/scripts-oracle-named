-------------------------------------------------------------------------------
--
-- Script:	big_sort_area.sql
-- Purpose:	to set a big sort area size prior to index creation
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept PctSGA "Percentage of SGA" 10

column SortAreaSize noprint new_value SortAreaSize

select
  greatest(dbb * round(sga * &PctSGA / dbb / 100), now)  SortAreaSize
from
  (select value now from sys.v_$parameter where name = 'sort_area_size')  sas,
  (select value dbb from sys.v_$parameter where name = 'db_block_size')  dbb,
  (select sum(value) sga from sys.v_$sga)  sga
/

alter session set sort_area_size = &SortAreaSize;
prompt sort_area_size set to &SortAreaSize

undefine PctSGA
undefine SortAreaSize

@restore_sqlplus_settings
