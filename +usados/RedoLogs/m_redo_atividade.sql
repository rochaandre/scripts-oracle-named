REM ****************************************************************************
REM *  Arquivo.: m_redo_atividade.sql 			                       *
REM *  Objetivo: Mostra Apresentar o mapeamento das atividades dos redo log.   *
REM *  Empresa.: Merotto & Bueno Ltda - Samuel Merotto                         *
REM *								               *
REM ****************************************************************************

PROMPT

REM Formatação

@a_ambiente_normal.sql

REM Formatação das colunas

COL vDtMes HEADING 'Date' FORMAT A10
col h00    for 9999 Head '00h'
col h01    for 9999 Head '01h'
col h02    for 9999 Head '02h'
col h03    for 9999 Head '03h'
col h04    for 9999 Head '04h'
col h05    for 9999 Head '05h'
col h06    for 9999 Head '06h'
col h07    for 9999 Head '07h'
col h08    for 9999 Head '08h'
col h09    for 9999 Head '09h'
col h10    for 9999 Head '10h'
col h11    for 9999 Head '11h'
col h12    for 9999 Head '12h'
col h13    for 9999 Head '13h'
col h14    for 9999 Head '14h'
col h15    for 9999 Head '15h'
col h16    for 9999 Head '16h'
col h17    for 9999 Head '17h'
col h18    for 9999 Head '18h'
col h19    for 9999 Head '19h'
col h20    for 9999 Head '20h'
col h21    for 9999 Head '21h'
col h22    for 9999 Head '22h'
col h23    for 9999 Head '23h'
COL db     NEW_VALUE vdb 

SPOOL resultado\m_redo_atividade-&vdb..res

SELECT to_char(to_Date(vDia,'yyyymmdd'), 'dd/mm/yyyy') vDtMes,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'00',1,0)) h00,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'01',1,0)) h01,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'02',1,0)) h02,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'03',1,0)) h03,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'04',1,0)) h04,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'05',1,0)) h05,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'06',1,0)) h06,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'07',1,0)) h07,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'08',1,0)) h08,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'09',1,0)) h09,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'10',1,0)) h10,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'11',1,0)) h11,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'12',1,0)) h12,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'13',1,0)) h13,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'14',1,0)) h14,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'15',1,0)) h15,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'16',1,0)) h16,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'17',1,0)) h17,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'18',1,0)) h18,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'19',1,0)) h19,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'20',1,0)) h20,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'21',1,0)) h21,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'22',1,0)) h22,
       SUM(DECODE(SUBSTR(vDiaHora,10,2),'23',1,0)) h23
FROM (select to_char(first_time, 'ddmmyyyy hh24') vDiaHora
            ,to_number(to_char(to_char(first_time, 'yyyymmdd'))) vDia
        from v$log_history
       order by 2 asc)
GROUP BY vDia
/

spool off

@a_ambiente_padrao.sql

PROMPT
PROMPT Arquivo gerado: resultado\m_redo_atividade-&vdb..res
PROMPT
