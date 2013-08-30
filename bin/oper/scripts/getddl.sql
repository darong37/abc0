set sqln off
set line 200
set pagesize 1000
set long 5000

select dbms_metadata.get_ddl('&1','&3','&2') from dual
/
