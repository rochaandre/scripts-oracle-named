-------------------------------------------------------------------------------
--
-- Script:	create_apt_extents.sql
-- Purpose:	to the apt_extents table
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description: The apt_extents table is used by other APT scripts to look up
--		the segment to which a particular block belongs.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

drop table
  sys.apt_extents
/
create table
  sys.apt_extents
  (
    file_id      number,
    block_id     number,
    owner        varchar2(30),
    segment_name varchar2(81),
    extent_id    number,
    blocks       number
  )
/
insert into sys.apt_extents
select
  file_id,
  block_id,
  owner,
  segment_name,
  extent_id,
  blocks
from
  sys.dba_extents
/
create index apt_extents_index
on apt_extents (
  file_id,
  block_id)
/

@restore_sqlplus_settings
