-- I/O Summary report

set linesize 120 pagesize 60 feedback off
set numformat 9999999.9

col drive format A5
col file_name format A40
col Total_IOs format 999999999.9
col Blocks_read format 999999999.9
col Blocks_written format 999999999.9
clear breaks
clear computes
break on drive skip 1 on report
compute sum of blocks_read on drive
compute sum of blocks_written on drive
compute sum of total_ios on drive
compute sum of blocks_read on report
compute sum of blocks_written on report
compute sum of total_ios on report
ttitle skip center "Database File I/O by Drive" Skip 2

Select upper(substr(df.name,1,1)) Drive,
       upper(df.name) File_Name,
       fs.phyblkrd+fs.phyblkwrt Total_IOs,
       fs.phyblkrd Blocks_read,
       fs.phyblkwrt Blocks_written
From   v$filestat fs,v$datafile df
where  df.file# = fs.file#
order by Total_IOs desc;
       
ttitle off       
clear breaks
clear computes

