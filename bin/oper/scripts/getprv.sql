set sqln off
set line 200
set pagesize 1000
set long 5000

select * from USER_TAB_PRIVS_MADE where TABLE_NAME = '&1'
/
