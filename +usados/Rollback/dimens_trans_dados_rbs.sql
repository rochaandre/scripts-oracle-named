/* Dimensionando Transa��o de Dados para Rollback
-- Deletes s�o caros
-- Inserts usam espa�o m�nimo de rollback
-- updates usam espa�o de rollback dependendo do n�mero de colunas
-- Manuten��o de �ndices adiona rollback
*/

SELECT S.USERNAME, T.USED_UBLK,T.START_TIME
FROM V$TRANSACTION T, V$SESSION S
WHERE T.ADDR= S.TADDR
/
