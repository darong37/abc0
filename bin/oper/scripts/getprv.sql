-- 1: owner 
-- 2: name  
set sqln off
set line 200
set pagesize 1000
set long 5000

select * from ALL_TAB_PRIVS_MADE where OWNER='&1' and TABLE_NAME = '&2'
/
