variable jobno number;
variable instno number;
begin
  select instance_number into :instno from v$instance;
  dbms_job.submit(:jobno, 
                  'sp_coleta_dados_crescimento;',
                  next_day(trunc(sysdate),'FRIDAY')+7/24,
                  'sysdate + 7',
                  TRUE,
                  :instno);
  commit;
end;


