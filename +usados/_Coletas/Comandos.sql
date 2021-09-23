select username,status from v$session
where osuser = lower('eduardon')
/