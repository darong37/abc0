--
-- 1: type  ex.(TABLE|VIEW)
-- 2: owner 
-- 3: name  
--
set sqln off
set line 200
set pagesize 1000
set long 5000

set echo off
set head off
set feedback off

select dbms_metadata.get_ddl('&1','&3','&2') from dual
/
