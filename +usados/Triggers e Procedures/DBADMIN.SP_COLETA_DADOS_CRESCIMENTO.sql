CREATE OR REPLACE  PROCEDURE 
    "DBADMIN"."SP_COLETA_DADOS_CRESCIMENTO"               
    "SP_COLETA_DADOS_CRESCIMENTO"  as
begin
  insert into crescimento_database
  select sysdate,
         a.tablespace_name,
         a.file_name,
         a.bytes,
         sum(b.bytes)
  from sys.dba_data_files a,
       sys.dba_free_space b
  where a.file_id = b.file_id
  group by a.tablespace_name,a.file_name,a.bytes;

  commit;

end sp_coleta_dados_crescimento;