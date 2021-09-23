SELECT s.owner, s.segment_name, s.segment_type, s.tablespace_name, 
       s.next_extent
    FROM dba_segments s, dba_tablespaces t
    WHERE s.next_extent * 2 > (SELECT max(f.bytes)
               FROM dba_free_space f
               WHERE f.tablespace_name = s.tablespace_name
                 AND f.tablespace_name = t.tablespace_name)
      AND s.tablespace_name = t.tablespace_name
      AND t.extent_management = 'DICTIONARY'


SELECT substr(owner, 1, 10), segment_type, substr(segment_name, 1, 25), extents, 
       s.max_extents
    FROM dba_segments s, dba_tablespaces t
    WHERE s.extents > s.max_extents * 0.75
      AND t.extent_management = 'DICTIONARY'
      AND s.tablespace_name = t.tablespace_name
      AND s.max_extents > 0
    ORDER BY t.tablespace_name