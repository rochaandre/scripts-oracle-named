SELECT A.CIRCUIT, 
       A.DISPATCHER, 
       A.SERVER, 
       A.STATUS       
FROM V$CIRCUIT A, 
     V$SESSION B       
WHERE A.SADDR = B.SADDR
/
