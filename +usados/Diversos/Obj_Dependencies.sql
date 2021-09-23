SET ECHO off 
REM NAME:  TFSODEP.SQL
REM USAGE:"@path/tfsodep" 
REM ------------------------------------------------------------------------ 
REM REQUIREMENTS: 
REM    SELECT on SYS.OBJ$, SYS.USER$ 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM    Tries to determine what objects an objects depends on and create 
REM    an immediate dependency chart. 
REM 
REM    Notes: 
REM 
REM    Object   'Dropped?' implies an object we depend on has been  
REM             dropped. We cannot tell what was dropped. 
REM 
REM    Type     '*Not Exist*' implies we rely on such a named object  
REM             NOT existing. If one comes into existance we need to  
REM             recompile.  The TIMESTAMP for 'Not Exists' type  
REM             objects is set to Oracles END-OF-TIME. 
REM 
REM    Timestamp -SAME- shows timestamp on object looks fine. 
REM                     NOTE that for '*Not Exist*' this can't give a true  
REM                     indication. 
REM             *NEWER* Named object is newer than the last recompile  
REM                     of this object. 
REM             *OLDER* Usually means an item that did not exist has  
REM                     been created thus meaning we need a recompile. 
REM ------------------------------------------------------------------------ 
REM EXAMPLE: 
REM    Enter OWNER pattern: scott 
REM    Enter OBJECT NAME pattern: s_i% 
REM 
REM    "Objects matching scott.s_i%" 
REM    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
REM 
REM      Obj# Object                             Type        Status 
REM    ------ ---------------------------------- ----------- ------- 
REM      9473 SCOTT.S_IMAGE                      TABLE       VALID 
REM      2636 SCOTT.S_IMAGE_ID                   SEQUENCE    VALID 
REM      9474 SCOTT.S_IMAGE_ID_PK                INDEX       VALID 
REM      9475 SCOTT.S_INVENTORY                  TABLE       VALID 
REM      9476 SCOTT.S_INVENTORY_PRODUCT_ID_PK    INDEX        VALID 
REM 
REM    Enter Object ID required: 9475 
REM 
REM 
REM    "Object 9475 is:" 
REM    "~~~~~~~~~~~~~~~~~~~" 
REM 
REM      Obj# Object                             Type        Status 
REM    ------ ---------------------------------- ----------- ------- 
REM    S-Tim 
REM    -------------------- 
REM      9475 SCOTT.S_INVENTORY                  TABLEVALID 
REM    25-JUN-1996 09:12:09 
REM   
REM 
REM    "Depends on:" 
REM    "~~~~~~~~~~~" 
REM  
REM ------------------------------------------------------------------------ 
REM Main text of script follows: 
 
 
set feedback off 
set ver off 
set pages 10000 
column Owner format "A10" 
column Obj#  format "99999" 
column Object format "A42" 
rem 
ACCEPT OWN   CHAR PROMPT "Enter OWNER pattern: " 
ACCEPT NAM   CHAR PROMPT "Enter OBJECT NAME pattern: " 
prompt 
prompt "Objects matching &&OWN..&&NAM" 
prompt "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
select o.obj# "Obj#", 
       decode(o.linkname, null, 
        u.name||'.'||o.name, 
        o.remoteowner||'.'||o.name||'@'||o.linkname) "Object", 
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER', 
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
     7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 
                      10, '*Not Exist*', 
                      11, 'PKG BODY', 12, 'TRIGGER', 'UNDEFINED') "Type", 
       decode(o.status,0,'N/A',1,'VALID', 'INVALID') "Status" 
  from sys.obj$ o, sys.user$ u 
 where owner#=user# 
   and u.name like upper('&&OWN') and o.name like upper('&&NAM') 
; 
prompt 
ACCEPT OBJID CHAR PROMPT "Enter Object ID required: " 
prompt 
prompt 
prompt "Object &&OBJID is:" 
prompt "~~~~~~~~~~~~~~~~~~~" 
select o.obj# "Obj#", 
       decode(o.linkname, null, 
        u.name||'.'||o.name, 
        o.remoteowner||'.'||o.name||'@'||o.linkname) "Object", 
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER', 
   4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 
                      10, '*Not Exist*', 
             11, 'PKG BODY', 12, 'TRIGGER', 'UNDEFINED') "Type", 
       decode(o.status,0,'N/A',1,'VALID', 'INVALID') "Status", 
       substr(to_char(stime,'DD-MON-YYYY HH24:MI:SS'),1,20) "S-Time" 
  from sys.obj$ o, sys.user$ u 
 where owner#=user# and o.obj#='&&OBJID' 
; 
prompt 
prompt "Depends on:" 
prompt "~~~~~~~~~~~" 
 
select o.obj# "Obj#", 
       decode(o.linkname, null, 
        nvl(u.name,'Unknown')||'.'||nvl(o.name,'Dropped?'), 
        o.remoteowner||'.'||nvl(o.name,'Dropped?')||'@'||o.linkname) "Object", 
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER', 
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 
                      10, '*Not Exist*', 
                      11, 'PKG BODY', 12, 'TRIGGER', 'UNDEFINED') "Type", 
        decode(sign(stime-P_TIMESTAMP), 
                  1,'*NEWER*',-1,'*?OLDER?*',null,'-','-SAME-')  
"TimeStamp", 
decode(o.status,0,'N/A',1,'VALID','INVALID') "Status" 
  from sys.dependency$ d,  sys.obj$ o, sys.user$ u 
 where P_OBJ#=obj#(+) and o.owner#=u.user#(+) and D_OBJ#='&&OBJID' 
; 
