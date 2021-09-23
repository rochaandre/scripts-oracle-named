SET PAGES 50
SET LINES 100
SET PAUSE ON
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  seg_owner                  varchar2(30);
  seg_name                   varchar2(81);
  seg_type                   varchar2(20);
  next_exts                   NUMBER;
  exts                       number;
  max_exts                   number;
  tbs_name                   varchar2(30);
  max_byte                   NUMBER;
  perc_free                  NUMBER(4);
  total_blocks               NUMBER;
  total_bytes                NUMBER;
  unused_blocks              NUMBER;
  unused_bytes               NUMBER;
  last_used_extent_file_id   NUMBER;
  last_used_extent_block_id  NUMBER;
  last_used_block            NUMBER;
  block_size                 number;
  tm_exts                    number;

  CURSOR seg_objs IS
  select owner, segment_name, segment_type, next_extent, extents,
         max_extents, tablespace_name
        from dba_segments S
       where next_extent >  (select max(bytes)
                   from dba_free_space F
            where F.tablespace_name = S.tablespace_name
            group by F.tablespace_name)  or  (extents > 100)
              and segment_type in ('TABLE','INDEX');
BEGIN
DBMS_OUTPUT.ENABLE(2000000);
 open seg_objs;
    select value into block_size from sys.V_$PARAMETER
        where name = 'db_block_size';
     loop  fetch seg_objs into seg_owner, seg_name, seg_type,
                    next_exts, exts, max_exts, tbs_name;

  exit when seg_objs%NOTFOUND;
  DBMS_SPACE.UNUSED_SPACE ( seg_owner,
                            seg_name,
                            seg_type,
                            total_blocks,
                            total_bytes,
                            unused_blocks,
                            unused_bytes,
                            last_used_extent_file_id,
                            last_used_extent_file_id,
                            last_used_block);
     perc_free := ((unused_bytes/total_bytes)*100);

    SELECT MAX(bytes)
        INTO max_byte      FROM dba_free_space
               WHERE tablespace_name = tbs_name     GROUP BY tablespace_name;
        IF ((next_exts > max_byte) OR       ((max_exts - exts) < 5)) THEN

 DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------');
 DBMS_OUTPUT.PUT_LINE('Tamanho do Bloco..: ['||block_size||']');
 DBMS_OUTPUT.PUT_LINE('Informacao........: 2K -> 121 , 4K -> 249 , 8K -> 505 ');
 DBMS_OUTPUT.PUT_LINE('Owner.............: ['||seg_owner||']');
 DBMS_OUTPUT.PUT_LINE('Segment Name......: ['||seg_name||']');
 DBMS_OUTPUT.PUT_LINE('Segment Type......: ['||seg_type||']');
 DBMS_OUTPUT.PUT_LINE('Next (bytes)......: ['||TO_CHAR(next_exts,'999,999,999,999')||']');
 DBMS_OUTPUT.PUT_LINE('Extents...........: ['||exts||']');
 DBMS_OUTPUT.PUT_LINE('Max Extents.......: ['||max_exts||']');
 DBMS_OUTPUT.PUT_LINE('Table Space Name..: ['||tbs_name||']');
 DBMS_OUTPUT.PUT_LINE('Max bytes.........: ['||TO_CHAR(max_byte,'999,999,999,999')||']');
 DBMS_OUTPUT.PUT_LINE('Used bytes........: ['||TO_CHAR(total_bytes,'999,999,999,999')||']');
 DBMS_OUTPUT.PUT_LINE('Free bytes........: ['||TO_CHAR(unused_bytes,'999,999,999,999')||']');
 DBMS_OUTPUT.PUT_LINE('% Free............: ['||TO_CHAR(perc_free,'999,999,999,999')||']');
 DBMS_OUTPUT.PUT_LINE('.');
 IF (next_exts > max_byte) THEN

  DBMS_OUTPUT.PUT_LINE('PROBLEM 1 ........: [Next > Max]['||TO_CHAR(next_exts,'999,999,999,999')||']>['||TO_CHAR(max_byte,'999
,999,999,999')||']');
 END IF;
       IF ((max_exts - exts) < 5) THEN
DBMS_OUTPUT.PUT_LINE('PROBLEM 2 ........: [MaxExt - Ext < 5]['||max_exts||']-['||exts||']');
  END IF;
  END IF;
   END LOOP;
   exception  when others then
    dbms_output.put_line('Saiu por exception.');
    dbms_output.put_line('SQLCODE  => '||sqlcode);
    close seg_objs;
    END;