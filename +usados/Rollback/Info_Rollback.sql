SET space 1 feedback OFF
TTITLE center 'Online Rollback Segments' left _date right _time SKIP 2
COLUMN name FORMAT a8
COLUMN extends FORMAT 9999 HEADING 'EXT'
COLUMN hwmsize FORMAT 999999999
COLUMN wraps FORMAT 9999
COLUMN shrinks FORMAT 9999999
COLUMN aveshrink FORMAT 999999999 HEADING 'AVE_SHR'
COLUMN aveactive FORMAT 999999999 HEADING 'AVE_ACT'

SELECT name, hwmsize, optsize, wraps, extends, shrinks, aveshrink, aveactive
FROM v$rollstat, v$rollname
WHERE v$rollstat.usn = v$rollname.usn;

PROMPT
PROMPT HWMSIZE - high water mark of rb_segment size
PROMPT OPTSIZE - optimal size of rb_segment
PROMPT WRAPS - number of times rb_segment wraps from one extent to another
PROMPT EXT - number of times a new extent is allocated for rb_segment
PROMPT SHRINKS - number of times Oracle has truncated extents from rb_segment
PROMPT AVE_SHR - average size of freed extents
PROMPT AVE_ACT - current average size of active extents in rb_segment

SET space 1 feedback ON
TTITLE OFF


