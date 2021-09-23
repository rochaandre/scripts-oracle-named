select s.segment_name, s.bytes / 1024 || 'K' suggest1, ceil(s.bytes / (10 * p.value)) * (p.value / 1024) || 'K' suggest2 
from  sys.dba_segments s,  sys.v_$parameter p
where owner = 'MIS'
/
