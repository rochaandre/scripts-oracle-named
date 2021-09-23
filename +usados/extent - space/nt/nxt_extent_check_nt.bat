@echo off
REM ##############################################################
REM PROGRAM NAME:	nxt_extent_check_nt.bat                                  
REM PURPOSE: 		Checks availability of space for next extent
REM USAGE:		c:\>nxt_extent_check_nt.bat SID
REM ###############################################################

REM :::::::::::::: Begin Declare Variables Section
 set ORA_HOME=d:\oracle\ora81\bin
 set CONNECT_USER="/ as sysdba"
 set ORACLE_SID=%1

 set TOOLS=c:\oracomn\admin\my_dba
 set LOGDIR=%TOOLS%\localog
 set LOGFILE=%LOGDIR%\%ORACLE_SID%.log
 set CFILE=c:\temp\nxt_extent_check.sql
REM :::::::::::::: End Declare Variables Section

REM :::::::::::::: Begin Parameter Checking Section 
if  "%1" == ""  goto usage

REM Create backup directories if already not exist 
if not exist %LOGDIR%       mkdir %LOGDIR%
REM :::::::::::::: End Parameter Checking Section 

REM :::::::::::::: Begin Create Dynamic files Section 
echo.                                            >%CFILE%
echo set heading off feedback off                >>%CFILE%
echo set linesize 300  pagesize 0                >>%CFILE%
echo set serveroutput on size 1000000            >>%CFILE%
echo SELECT 'EXTENT_FAIL:'^|^|'Tablespace:'^|^|  >>%CFILE%
echo         tablespace_name^|^|','^|^|          >>%CFILE%
echo       'Owner:'^|^|owner^|^|','^|^|          >>%CFILE%
echo       'Name:'^|^|segment_name^|^|','^|^|    >>%CFILE%
echo       'Type:'^|^|segment_type^|^|','^|^|    >>%CFILE%
echo       'Next:'^|^|next_extent                >>%CFILE%
echo FROM   dba_segments     OUTER               >>%CFILE%
echo WHERE owner not in ('SYSTEM','SYS')                         >>%CFILE%
echo AND NOT EXISTS (SELECT 'X'                                  >>%CFILE%
echo          FROM dba_free_space INNER                          >>%CFILE%
echo          WHERE OUTER.tablespace_name=INNER.tablespace_name  >>%CFILE%
echo            AND  bytes ^>= next_extent );                    >>%CFILE%
echo exit                                                        >>%CFILE%
REM ::::::::::::: End Create Dynamic files Section 

REM :::::::::::::: Begin extent checking Section 
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @%CFILE% >> %LOGFILE%
 (echo Next extent space check completed Successfully & date/T) >> %LOGFILE%
goto end
REM :::::::::::::: End extent checking Section 

REM :::::::::::::: Begin Error handling section
:usage
  echo Error, Usage: nxt_extent_check_nt.bat SID 
  goto end
REM :::::::::::::: End Error handling section

REM :::::::::::::: Cleanup  Section
:end
set ORA_HOME=
set ORACLE_SID=
set CONNECT_USER=
set CFILE=

