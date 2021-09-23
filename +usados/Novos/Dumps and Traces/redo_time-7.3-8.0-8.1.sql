-------------------------------------------------------------------------------
--
-- Script:	redo_time.sql
-- Purpose:	to calculate a time as required for a redo dump
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column yy new_value yy
column mm new_value mm
column dd new_value dd
column hh new_value hh
column mi new_value mi
column ss new_value ss

set termout off
select
  to_char(sysdate, 'YYYY')  yy,
  to_char(sysdate, 'MM')    mm,
  to_char(sysdate, 'DD')    dd,
  to_char(sysdate, 'HH24')  hh,
  to_char(sysdate, 'MI')    mi,
  to_char(sysdate, 'SS')    ss
from
  dual
/
set termout on

@accept yy "Year        " &yy
@accept mm "Month  (01-12)" &mm
@accept dd "Day    (01-31)" &dd
@accept hh "Hour   (00-23)" &hh
@accept mi "Minute (00-59)" &mi
@accept ss "Second (00-59)" &ss

select
  ((((((&yy  - 1988 ))*12 + &mm - 1)*31 + &dd - 1)*24 + &hh )*60 + &mi )*60 + &ss
    redo_time
from
  dual
/

undefine yy
undefine mm
undefine dd
undefine hh
undefine mi
undefine ss

@restore_sqlplus_settings
