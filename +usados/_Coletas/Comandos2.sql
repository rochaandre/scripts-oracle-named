declare x varchar2(100);
begin
  select  'EXECUTE DBMS_JOB.REMOVE('||job||');'
  into x 
  FROM DBA_JOBS
  where SUBSTR(WHAT,1,35) ='exec sp_coleta_dados_crescimento;'
  execute immediate x;
end;