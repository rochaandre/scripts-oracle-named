-------------------------------------------------------------------------------
--
-- Script:	public_synonym_users.sql
-- Purpose:	to show the number of users for each public synonym
-- For:		8.0 or 8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column public_synonym format a30

select
  so.kglnaobj  public_synonym,
  count(distinct no.kglnaown)  users
from
  sys.x_$kglob  so,			-- synonym object
  sys.x_$kgldp  sd,			-- synonym dependency
  sys.x_$kgldp  nd,			-- non-existent dependency
  sys.x_$kglob  no			-- non-existent object
where
  so.inst_id = userenv('Instance') and
  sd.inst_id = userenv('Instance') and
  nd.inst_id = userenv('Instance') and
  no.inst_id = userenv('Instance') and
  so.kglnaown = 'PUBLIC' and
  so.kglobtyp = 5 and			-- synonym
  sd.kglrfhdl = so.kglhdadr and
  nd.kglhdadr = sd.kglhdadr and
  nd.kglrfhdl = no.kglhdadr and
  no.kglobtyp = 0 and			-- non-existent
  no.kglnaobj = so.kglnaobj		-- same name
group by
  so.kglnaobj
order by 2
/

@restore_sqlplus_settings
