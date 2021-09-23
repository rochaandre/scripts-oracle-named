@echo off
REM ##############################################################
REM PROGRAM NAME:	space_check_nt.bat                                  
REM PURPOSE: 		Checks for tablespaces whcih are used beyond
REM                     given percent limit
REM USAGE:		c:\>space_check_nt.bat SID TBSUSED
REM ###############################################################

REM :::::::::::::: Begin Declare Variables Section
 set ORA_HOME=d:\oracle\ora81\bin
 set CONNECT_USER="/ as sysdba"
 set ORACLE_SID=%1
 set TBSUSED=%2

 set TOOLS=c:\oracomn\admin\my_dba
 set LOGDIR=%TOOLS%\localog
 set LOGFILE=%LOGDIR%\%ORACLE_SID%.log
 set CFILE=c:\temp\space_check.sql
REM :::::::::::::: End Declare Variables Section

REM :::::::::::::: Begin Parameter Checking Section 
if  "%1" == ""  goto usage
if  "%2" == ""  goto usage

REM Create backup directories if already not exist 
if not exist %LOGDIR%       mkdir %LOGDIR%
REM :::::::::::::: End Parameter Checking Section 

REM :::::::::::::: Begin Create Dynamic files Section 
echo.                                       >%CFILE%
echo set heading off feedback off           >>%CFILE%
echo set linesize 300  pagesize 0	    >>%CFILE%
echo set serveroutput on size 1000000       >>%CFILE%

echo create or replace view temprpt_free            >>%CFILE%
echo as select tablespace_name,sum(bytes) free      >>%CFILE%
echo from dba_free_space                            >>%CFILE%
echo group by tablespace_name;                      >>%CFILE%

echo create or replace view temprpt_bytes as        >>%CFILE%
echo select tablespace_name,sum(bytes) bytes        >>%CFILE%
echo from dba_data_files                            >>%CFILE%
echo group by tablespace_name;                      >>%CFILE%

echo create or replace view temprpt_status as       >>%CFILE%
echo select a.tablespace_name,free,bytes            >>%CFILE%
echo from temprpt_bytes a,temprpt_free b            >>%CFILE%
echo where a.tablespace_name=b.tablespace_name(+);  >>%CFILE%

echo create or replace view temprpt_trouble as                   >>%CFILE%
echo        select tablespace_name,                              >>%CFILE%
echo        round(bytes/(1024*1024),1)                 Size_Mb,  >>%CFILE%
echo        round(nvl(bytes-free,bytes)/(1024*1024),1) Used_Mb,  >>%CFILE%
echo        round(nvl(free,0)/(1024*1024),1)           Free_Mb,  >>%CFILE%
echo        round(nvl(100*(bytes-free)/bytes,100),1)   Used_pct  >>%CFILE%
echo from temprpt_status;                                        >>%CFILE%

echo select 'TABLESPACE_THRESHOLD_FAIL:'^|^|'TableSpace:'^|^|    >>%CFILE%
echo        ltrim(rtrim(tablespace_name))^|^|','^|^|             >>%CFILE%
echo       'Size(Mb):'^|^|Size_Mb^|^|','^|^|'Used(Mb):'^|^|      >>%CFILE%
echo        Used_Mb^|^|','^|^|                                   >>%CFILE%
echo       'Free(Mb):'^|^|Free_Mb^|^|','^|^|'%Used:'^|^|Used_pct >>%CFILE%
echo from temprpt_trouble                                        >>%CFILE%
echo where used_pct ^>= %TBSUSED%;                               >>%CFILE%
echo exit                                                        >>%CFILE%
REM ::::::::::::: End Create Dynamic files Section 

REM :::::::::::::: Begin TBS checking Section 
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @%CFILE% >> %LOGFILE%
 (echo Tablespace space check completed Successfully  & date/T) >> %LOGFILE%
goto end
REM :::::::::::::: End TBS checking Section 

REM :::::::::::::: Begin Error handling section
:usage
  echo Error, Usage: space_check_nt.bat SID TBSUSED
  goto end
REM :::::::::::::: End Error handling section

REM :::::::::::::: Cleanup  Section
:end
set ORA_HOME=
set ORACLE_SID=
set TBSUSED=
set CONNECT_USER=
set CFILE=

