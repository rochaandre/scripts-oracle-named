ORADIM -NEW -SID DBTEST -INTPWD oracle -STARTMODE a -PFILE C:\oracle\ora92\admin\dbtest\pfile\initdbtest.ora

startup nomount pfile = C:\oracle\ora92\admin\dbtest\pfile\initdbtest.ora

CREATE DATABASE dbtest
   MAXLOGFILES 32
   MAXLOGMEMBERS 5
   MAXLOGHISTORY 100
   MAXDATAFILES 100
LOGFILE
   GROUP 1 'C:\ORACLE\ORA92\ORADATA\DBTEST\REDO01.LOG'  SIZE 1M reuse,
   GROUP 2 'C:\ORACLE\ORA92\ORADATA\DBTEST\REDO02.LOG'  SIZE 1M reuse,
   GROUP 3 'C:\ORACLE\ORA92\ORADATA\DBTEST\REDO03.LOG'  SIZE 1M reuse
DATAFILE
  'C:\ORACLE\ORA92\ORADATA\dbtest\SYSTEM01.DBF' SIZE 2m reuse AUTOEXTEND ON
DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE 
  'C:\oracle\ORA92\ORADATA\dbtest\temp01.dbf' SIZE 10M reuse
UNDO TABLESPACE 
   UNDOTBS1 DATAFILE 'C:\ORACLE\ORA92\ORADATA\dbtest\UNDOTBS101.dbf'size 10M reuse
CHARACTER SET WE8MSWIN1252
NATIONAL CHARACTER SET AL16UTF16;