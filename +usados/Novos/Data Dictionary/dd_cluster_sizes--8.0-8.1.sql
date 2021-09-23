-------------------------------------------------------------------------------
--
-- Script:	dd_cluster_size.sql
-- Purpose:	show recommended min size for main data dictionary clusters
-- For:		8.0 and 8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
    'C_OBJ#' "CLUSTER",
    round(
	avg(
	    ts.bytes +
	    tcs.bytes +
	    nvl(xs.bytes, 0) +
	    nvl(xcs.bytes, 0)
	) +
	stddev(
	    ts.bytes +
	    tcs.bytes +
	    nvl(xs.bytes, 0) +
	    nvl(xcs.bytes, 0)
	)
    ) "MIN SIZE"
from
    (   select
	    t.OBJ#,
	    37 +
	    vsize(nvl(t.OBJ#, 0)) +
	    vsize(nvl(t.DATAOBJ#, 0)) +
	    vsize(nvl(t.TS#, 0)) +
	    vsize(nvl(t.FILE#, 0)) +
	    vsize(nvl(t.BLOCK#, 0)) +
	    vsize(nvl(t.BOBJ#, 0)) +
	    vsize(nvl(t.TAB#, 0)) +
	    vsize(nvl(t.COLS, 0)) +
	    vsize(nvl(t.CLUCOLS, 0)) +
	    vsize(nvl(t.PCTFREE$, 0)) +
	    vsize(nvl(t.PCTUSED$, 0)) +
	    vsize(nvl(t.INITRANS, 0)) +
	    vsize(nvl(t.MAXTRANS, 0)) +
	    vsize(nvl(t.FLAGS, 0)) +
	    vsize(nvl(t.AUDIT$, 0)) +
	    vsize(nvl(t.ROWCNT, 0)) +
	    vsize(nvl(t.BLKCNT, 0)) +
	    vsize(nvl(t.EMPCNT, 0)) +
	    vsize(nvl(t.AVGSPC, 0)) +
	    vsize(nvl(t.CHNCNT, 0)) +
	    vsize(nvl(t.AVGRLN, 0)) +
	    vsize(nvl(t.AVGSPC_FLB, 0)) +
	    vsize(nvl(t.FLBCNT, 0)) +
	    vsize(nvl(t.ANALYZETIME, sysdate)) +
	    vsize(nvl(t.SAMPLESIZE, 0)) +
	    vsize(nvl(t.DEGREE, 0)) +
	    vsize(nvl(t.INSTANCES, 0)) +
	    vsize(nvl(t.INTCOLS, 0)) +
	    vsize(nvl(t.KERNELCOLS, 0)) +
	    vsize(nvl(t.PROPERTY, 0)) +
	    vsize(nvl(t.TRIGFLAG, 0)) +
	    vsize(nvl(t.SPARE1, 0)) +
	    vsize(nvl(t.SPARE2, 0)) +
	    vsize(nvl(t.SPARE3, 0)) +
	    vsize(nvl(t.SPARE4, 0)) +
	    vsize(nvl(t.SPARE5, 0)) +
	    vsize(nvl(t.SPARE6, sysdate))  bytes
	from
	    sys.tab$  t
    )  ts,
    (	select
	    tc.OBJ#,
	    sum(
		23 +
		vsize(nvl(tc.COL#, 0)) +
		vsize(nvl(tc.SEGCOL#, 0)) +
		vsize(nvl(tc.SEGCOLLENGTH, 0)) +
		vsize(nvl(tc.OFFSET, 0)) +
		vsize(nvl(tc.NAME, 0)) +
		vsize(nvl(tc.TYPE#, 0)) +
		vsize(nvl(tc.LENGTH, 0)) +
		vsize(nvl(tc.FIXEDSTORAGE, 0)) +
		vsize(nvl(tc.PRECISION#, 0)) +
		vsize(nvl(tc.SCALE, 0)) +
		vsize(nvl(tc.NULL$, 0)) +
		vsize(nvl(tc.DEFLENGTH, 0)) +
		1 +
		vsize(nvl(tc.INTCOL#, 0)) +
		vsize(nvl(tc.PROPERTY, 0)) +
		vsize(nvl(tc.CHARSETID, 0)) +
		vsize(nvl(tc.CHARSETFORM, 0)) +
		vsize(nvl(tc.SPARE1, 0)) +
		vsize(nvl(tc.SPARE2, 0)) +
		vsize(nvl(tc.SPARE3, 0)) +
		vsize(nvl(tc.SPARE4, 0)) +
		vsize(nvl(tc.SPARE5, 0)) +
		vsize(nvl(tc.SPARE6, sysdate))
	    ) bytes
	from
	    sys.col$  tc
	group by
	    tc.OBJ#
    )  tcs,
    (   select
	    i.BO#,
	    sum(
		34 +
		vsize(nvl(i.OBJ#, 0)) +
		vsize(nvl(i.DATAOBJ#, 0)) +
		vsize(nvl(i.TS#, 0)) +
		vsize(nvl(i.FILE#, 0)) +
		vsize(nvl(i.BLOCK#, 0)) +
		vsize(nvl(i.BO#, 0)) +
		vsize(nvl(i.INDMETHOD#, 0)) +
		vsize(nvl(i.COLS, 0)) +
		vsize(nvl(i.PCTFREE$, 0)) +
		vsize(nvl(i.INITRANS, 0)) +
		vsize(nvl(i.MAXTRANS, 0)) +
		vsize(nvl(i.PCTTHRES$, 0)) +
		vsize(nvl(i.TYPE#, 0)) +
		vsize(nvl(i.FLAGS, 0)) +
		vsize(nvl(i.PROPERTY, 0)) +
		vsize(nvl(i.BLEVEL, 0)) +
		vsize(nvl(i.LEAFCNT, 0)) +
		vsize(nvl(i.DISTKEY, 0)) +
		vsize(nvl(i.LBLKKEY, 0)) +
		vsize(nvl(i.DBLKKEY, 0)) +
		vsize(nvl(i.CLUFAC, 0)) +
		vsize(nvl(i.ANALYZETIME, sysdate)) +
		vsize(nvl(i.SAMPLESIZE, 0)) +
		vsize(nvl(i.ROWCNT, 0)) +
		vsize(nvl(i.INTCOLS, 0)) +
		vsize(nvl(i.DEGREE, 0)) +
		vsize(nvl(i.INSTANCES, 0)) +
		vsize(nvl(i.TRUNCCNT, 0)) +
		vsize(nvl(i.SPARE1, 0)) +
		vsize(nvl(i.SPARE2, 0)) +
		vsize(nvl(i.SPARE3, 0)) +
		vsize(nvl(i.SPARE4, 0)) +
		vsize(nvl(i.SPARE5, 0)) +
		vsize(nvl(i.SPARE6, sysdate))
	    ) bytes
	from
	    sys.ind$  i
	group by
	    i.BO#
    )  xs,
    (	select
	    ic.BO#,
	    sum(
		13 +
		vsize(nvl(ic.OBJ#, 0)) +
		vsize(nvl(ic.COL#, 0)) +
		vsize(nvl(ic.POS#, 0)) +
		vsize(nvl(ic.SEGCOL#, 0)) +
		vsize(nvl(ic.SEGCOLLENGTH, 0)) +
		vsize(nvl(ic.OFFSET, 0)) +
		vsize(nvl(ic.INTCOL#, 0)) +
		vsize(nvl(ic.SPARE1, 0)) +
		vsize(nvl(ic.SPARE2, 0)) +
		vsize(nvl(ic.SPARE3, 0)) +
		vsize(nvl(ic.SPARE4, 0)) +
		vsize(nvl(ic.SPARE5, 0)) +
		vsize(nvl(ic.SPARE6, sysdate))
	    ) bytes
	from
	    sys.icol$  ic
	group by
	    ic.BO#
    )  xcs
where
    tcs.OBJ# = ts.OBJ# and
    xs.BO# (+) = ts.OBJ# and
    xcs.BO# (+) = ts.OBJ#
union all
select
    'C_FILE#_BLOCK#' "CLUSTER",
    round(avg(ss.bytes + us.bytes) + stddev(ss.bytes + us.bytes)) "MIN SIZE"
from
    (   select
	    s.TS#,
	    s.FILE#,
	    s.BLOCK#,
	    20 +
	    vsize(nvl(s.FILE#, 0)) +
	    vsize(nvl(s.BLOCK#, 0)) +
	    vsize(nvl(s.TYPE#, 0)) +
	    vsize(nvl(s.TS#, 0)) +
	    vsize(nvl(s.BLOCKS, 0)) +
	    vsize(nvl(s.EXTENTS, 0)) +
	    vsize(nvl(s.INIEXTS, 0)) +
	    vsize(nvl(s.MINEXTS, 0)) +
	    vsize(nvl(s.MAXEXTS, 0)) +
	    vsize(nvl(s.EXTSIZE, 0)) +
	    vsize(nvl(s.EXTPCT, 0)) +
	    vsize(nvl(s.USER#, 0)) +
	    vsize(nvl(s.LISTS, 0)) +
	    vsize(nvl(s.GROUPS, 0)) +
	    vsize(nvl(s.BITMAPRANGES, 0)) +
	    vsize(nvl(s.CACHEHINT, 0)) +
	    vsize(nvl(s.SCANHINT, 0)) +
	    vsize(nvl(s.HWMINCR, 0)) +
	    vsize(nvl(s.SPARE1, 0)) +
	    vsize(nvl(s.SPARE2, 0))  bytes
	from
	    sys.seg$ s
    ) ss,
    (   select
	    u.TS#,
	    u.SEGFILE#,
	    u.SEGBLOCK#,
	    sum(
		4 +
		vsize(nvl(u.EXT#, 0)) +
		vsize(nvl(u.FILE#, 0)) +
		vsize(nvl(u.BLOCK#, 0)) +
		vsize(nvl(u.LENGTH, 0)) 
	    )  bytes
	from
	    sys.uet$ u
	group by
	    u.TS#,
	    u.SEGFILE#,
	    u.SEGBLOCK#
    ) us
where
    ss.TS# = us.TS# and
    ss.FILE# = us.SEGFILE# and
    ss.BLOCK# = us.SEGBLOCK#
/

@restore_sqlplus_settings
