-------------------------------------------------------------------------------
--
-- Script:	nice_shared_pool_flush.sql
-- Purpose:	to flush the shared pool without losing sequence numbers
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@keeper

alter system flush shared_pool
/

