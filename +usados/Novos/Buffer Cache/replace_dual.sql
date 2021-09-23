-------------------------------------------------------------------------------
--
-- Script:	replace_dual.sql
-- Purpose:	to replace the SYS.DUAL table with a view onto X$DUAL
-- For:		8.1 (should be OK against 8.0 but not yet tested)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------

create view dual_view as select dummy from x$dual;
grant select on dual_view to public;
rename dual to dual_table;
rename dual_view to dual;
