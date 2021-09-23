-- verificar o status da instala��o do APEX
SELECT  STATUS 
FROM    DBA_REGISTRY
WHERE   COMP_ID = 'APEX';

-- verificar a vers�o do APEX
SELECT * FROM apex_release;

-- verificar todas as vers�es do APEX instaladas
SELECT  VERSION 
FROM    DBA_REGISTRY 
WHERE   COMP_NAME = 'Oracle Application Express';