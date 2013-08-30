set sqln off
set line 200
set pagesize 1000
set long 5000

select * from all_objects where object_name='&1'
/
