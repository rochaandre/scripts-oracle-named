-------------------------------------------------------------------------------
--
-- Script:	keeper.sql
-- Purpose:	to "keep" reusable objects while free memory is abundant
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	This script is intended to be run regularly from cron.
--		It keeps all in-use keepable database objects.
--		It also keeps some cursors early in the life of the instance,
--		when reserved permanent memory is still available.
--
-------------------------------------------------------------------------------
@restore_sqlplus_settings
set feedback on

declare
  cursor candidate_objects is
    select /*+ ordered */
      decode(
        x.kglhdnsp,
        0, x.kglhdpar ||','|| x.kglnahsh,  -- 'address,hash_value' for cursors
        x.kglnaown ||'.'|| x.kglnaobj	   -- 'schema.object_name' for others
      ),
      decode(x.kglhdnsp, 0, 'C', decode(x.kglobtyp, 6, 'Q', 12, 'R', 'P'))
    from
      (
        select
	  decode(upper(substr(w.value,length(w.value),1)),
	    'M', substr(w.value, 1, length(w.value) - 1) * 1024 * 1024,
	    'K', substr(w.value, 1, length(w.value) - 1) * 1024,
	    w.value) -
	  decode(upper(substr(r.value,length(r.value),1)),
	    'M', substr(r.value, 1, length(r.value) - 1) * 1024 * 1024,
	    'K', substr(r.value, 1, length(r.value) - 1) * 1024,
	    r.value)  pool_body
        from
          sys.v_$parameter  w,
          sys.v_$parameter  r
        where
          w.name = 'shared_pool_size' and
          r.name = 'shared_pool_reserved_size'
      )  a,
      (
        select
          sum(p.ksmchsiz)  used_memory
        from
          sys.x_$ksmsp  p
        where
          p.inst_id = userenv('Instance') and
          p.ksmchcls in ('free', 'recr', 'freeabl') and
          p.ksmchsiz < 33554432			-- exclude large free chuncks
      )  b,
      sys.x_$kglob  x
    where
      x.inst_id = userenv('Instance') and
      x.kglhdkmk = 0 and			-- not yet kept
      (
        x.kglobtyp in (6, 7, 8, 9, 12) or	-- keepable database objects
        (					-- or
          x.kglobhs6 > 0 and			-- loaded
          x.kglhdnsp = 0 and			-- cursors
          x.kglobt12 >= 3 and			-- with 3 or more parse calls
          b.used_memory < a.pool_body * .8	-- if abundant memory
        )
      )
    group by
      decode(kglhdnsp, 0, kglhdpar ||','|| kglnahsh, kglnaown ||'.'|| kglnaobj),
      decode(kglhdnsp, 0, 'C', decode(kglobtyp, 6, 'Q', 12, 'R', 'P'))
    having
      count(decode(bitand(kglobflg, 1), 0, 1)) = 0 and	-- no invalid version
      count(*) <= 4;				-- no more than 4 versions

  object_name varchar2(160);
  object_type char(1);

begin
  open candidate_objects;
  loop
    fetch candidate_objects into object_name, object_type;
    exit when candidate_objects%notfound;
    sys.dbms_shared_pool.keep(object_name, object_type);
  end loop;
end;   
/

@restore_sqlplus_settings
