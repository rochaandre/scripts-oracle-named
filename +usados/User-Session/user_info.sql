--Gives user information like date created,default tablespace
--temporary tablespace, Roles assigned

col username  format a15
col "default ts"   format a15
col "temporary ts" format a15
col roles format a25
col profile format a10

break on username on created on "default TS" on "Temporary TS" on profile

select username,created,
       default_tablespace "Default TS",
       temporary_tablespace "Temporary TS",
       profile,
       Granted_role "roles"
from sys.dba_users,sys.dba_role_privs
where username = grantee(+)
order by username;