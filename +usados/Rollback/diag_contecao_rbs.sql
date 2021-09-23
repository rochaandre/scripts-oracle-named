SET LINES 150
SET PAGES 2000
SET FEED OFF
SET ECHO OFF

REM #######################################################
REM ###### DIAGNOSTICANDO CONTEÇÃO  SEGMENTO ROLLBACK #####
REM #######################################################
REM ###### NOTA: O NUMERO DE  "WAITS"  PARA  QUALQUER #####
REM ###### CLASE DEVE SER MENOR QUE 1% DO NUMERO  DE  #####
REM ###### REQUERIMENTOS. SENÃO CRIAR MAIS SEGMENTOS  #####     
REM ###### DE ROLLBACK				      #####
REM #######################################################

DECLARE 
V_GETS         NUMBER:= null;
V_CONSIST_GETS NUMBER:= null;
V_RESULT       NUMBER:= null;

BEGIN
   SELECT SUM(GETS) INTO V_GETS         FROM V$ROLLSTAT;
   SELECT VALUE     INTO V_CONSIST_GETS FROM V$SYSSTAT
      WHERE NAME='consistent gets';
   SELECT V_CONSIST_GETS / V_GETS INTO V_RESULT FROM DUAL;
dbms_output.put_line(TRUNC(V_RESULT,2));
END;
/