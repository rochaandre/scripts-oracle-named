@echo off
REM ##############################################################
REM PROGRAM NAME:	extent_count_nt.bat                                  
REM PURPOSE: 		Checks for segments which are extended beyond 
REM                             given number of extents
REM USAGE:		c:\>extent_count_nt.bat SID ECOUNT
REM ###############################################################

REM :::::::::::::: Begin Declare Variables Section
 set ORA_HOME=d:\oracle\ora81\bin
 set CONNECT_USER="/ as sysdba"
 set ORACLE_SID=%1
 set ECOUNT=%2

 set TOOLS=c:\oracomn\admin\my_dba
 set LOGDIR=%TOOLS%\localog
 set LOGFILE=%LOGDIR%\%ORACLE_SID%.log
 set CFILE=c:\temp\extent_count.sql
REM :::::::::::::: End Declare Variables Section

REM :::::::::::::: Begin Parameter Checking Section 
if  "%1" == ""  goto usage
if  "%2" == ""  goto usage

REM Create backup directories if already not exist 
if not exist %LOGDIR%       mkdir %LOGDIR%
REM :::::::::::::: End Parameter Checking Section 

REM :::::::::::::: Begin Create Dynamic files Section 
echo.                                                         >%CFILE%
echo set heading off feedback off 	                      >>%CFILE%
echo set linesize 300  pagesize 0                             >>%CFILE%
echo set serveroutput on size 1000000                         >>%CFILE%
echo select 'EXTENT_THRESHOLD_FAIL:'^|^|                      >>%CFILE%
echo        'Owner:'^|^|ltrim(rtrim(owner))^|^|','^|^|        >>%CFILE%
echo        'Name:'^|^|ltrim(rtrim(segment_name))^|^|','^|^|  >>%CFILE%
echo        'Type:'^|^|ltrim(rtrim(segment_type))^|^|','^|^|  >>%CFILE%
echo        'Tablespace:'^|^|ltrim(rtrim(tablespace_name))    >>%CFILE%
echo from dba_segments                                        >>%CFILE% 
echo where extents ^> %ECOUNT%                                >>%CFILE%
echo and owner in('SYS','SYSTEM');                            >>%CFILE%
echo exit                                                     >>%CFILE%
REM ::::::::::::: End Create Dynamic files Section 

REM :::::::::::::: Begin extent checking Section 
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @%CFILE% >> %LOGFILE%
 (echo Extent count check completed Successfully & date/T) >> %LOGFILE%
goto end
REM :::::::::::::: End extent checking Section 

REM :::::::::::::: Begin Error handling section
:usage
  echo Error, Usage: extent_count_nt.bat SID ECOUNT
  goto end
REM :::::::::::::: End Error handling section

REM :::::::::::::: Cleanup  Section
:end
set ORA_HOME=
set ORACLE_SID=
set ECOUNT=
set CONNECT_USER=
set CFILE=

