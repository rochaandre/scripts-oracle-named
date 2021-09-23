 SELECT DISTINCT 'alter database datafile '||''''||D.FILE_NAME||''''||' resize 12G;'
 FROM DBA_DATA_FILES D, DBA_EXTENTS E
 WHERE D.FILE_ID = E.FILE_ID
 and upper(D.FILE_NAME) like '%PCPEDI%'
 AND SEGMENT_NAME = ''
/