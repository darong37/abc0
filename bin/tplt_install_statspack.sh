#!/bin/sh -u

typeset SID=$1


#############
cat <<-__TEMPLATE__
	su - ora${SID}

	. ./${SID}.env

	cd ~/tmp

	sqlplus / as sysdba

	SELECT INSTANCE_NAME FROM V\$INSTANCE ;

	select file_name from dba_data_files where rownum <2 ;

__TEMPLATE__
#############


typeset basedir
echo -n '    Please Input Base Directory for data-file: '
read basedir
echo
echo


#############
cat <<-__TEMPLATE__
	create tablespace STASTBS datafile '$basedir/stattbs01.dbf'
	 size 150m AUTOEXTEND ON NEXT 10m maxsize 2048m ;

	select tablespace_name from dba_data_files where tablespace_name = 'STASTBS';
	select tablespace_name from dba_tablespace_groups where group_name = 'TEMP';
	select username from dba_users where username = 'PERFSTAT';

	define default_tablespace='STASTBS'
	define temporary_tablespace='TEMP'
	define perfstat_password='PERFSTAT'
	@?/rdbms/admin/spcreate.sql

__TEMPLATE__
#############

