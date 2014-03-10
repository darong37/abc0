
## Windows Event Log ID
Start Log Service: 6005
Shutdown: 6006

> 2014/03/03 15:14:11 更新

------------------


## 未使用ブロック情報
	select 
	        fs.file_id
	    ,   df.file_name
	    ,   fs.block_id
	    ,   fs.bytes/8/1024  "size"
	    ,   fs.block_id + fs.bytes/8/1024 "next ID"
	    ,   max(fs.block_id) over ( partition by fs.file_id)
	            max_block
	from  dba_free_space fs
	join  dba_data_files df 
	      on df.file_id = fs.file_id
	where fs.tablespace_name = upper('"&TABLESPACE_NAME&"')
	order by fs.file_id,fs.block_id;

> 2014/02/27 14:07:26 更新

------------------


## 表領域、データファイル一覧

	set pagesize 1000
	set linesize 200
	col TABLESPACE_NAME for a20
	col FILE_NAME for a50
	col MAXBYTES for 99999999999999
	select tablespace_name, file_name, bytes/1024/1024 MBytes, autoextensible, maxbytes/1024/1024 MaxMBytes
	from dba_data_files
	order by tablespace_name, file_name ;

> 2014/02/26 18:48:06 更新

------------------


## Msys bashの起動

	\.abc\.sys\bin\bash.exe --login -i -c

> 2014/02/26 11:33:49 更新

------------------


## ＤＤＬ文の取得
表「emp」のＤＤＬ文を取得

	set long 2000
	set heading off
	
	select
	dbms_metadata.get_ddl('TABLE','EMP')
	from dual;

> 2014/02/26 11:05:03 更新

------------------

## カラムのコメントの参照方法
	set pages 1000
	set line 132
	col OWNER for a4
	col TABLE_NAME for a20
	col COLUMN_NAME for a16
	col COMMENTS for a64

	select * from DBA_COL_COMMENTS where TABLE_NAME = 'DBA_DATA_FILES';


> 2014/02/21 17:03:53 更新

-------------

## cron登録
	# root でログイン
	cd /var/spool/cron/crontabs/
	pwd

	# cronジョブ設定のバックアップ
	ls -l
	crontab -l
	cp -pi root root.$(date '+%Y%m%d_%H%M%S')
	ls -l

	#一時ファイルの作成と編集
	cp -i root root.tmp
	vi root.tmp

	# G
	# $
	# a
	# リターン
	# 以下をペースト
	50 2 * * 0,1,2,3,4,5,6 /oraapp/home/log_rotate.sh >/dev/null 2>&1
	00 7 * * 0,1,2,3,4,5,6 /oraapp/home/log_purge.sh >/dev/null 2>&1
	00 8 * * 0,1,2,3,4,5,6 /bin/su - oracle -c "tablespace_check_uat.sh" >/dev/null 2>&1
	# エスケープ
	# :wq

	# 内容確認
	cat root.tmp
	diff root root.tmp

	# 設定の反映
	crontab root.tmp
	crontab -l

	# 後始末
	rm -i root.tmp
	ls -l




> 2014/02/21 16:09:03 更新

------------------

# Gitレポジトリを移行する方法

	git clone --mirror <SOURCE_REPOSITORY_URL>
	cd <REPOSITORY>
	git push --mirror <DESTINATION_REPOSITORY_URL>


> 2014/02/20 09:59:23 更新

-------------

##  
	ps auwxx

> 2014/02/20 18:35:46 更新

-------------

## クーロン登録

>

> 2014/02/20 17:50:16 更新

-------------

## hoge


> 2014/02/20 16:53:57 更新

-------------

## Gitレポジトリを移行する方法

	git clone --mirror <SOURCE_REPOSITORY_URL>
	cd <REPOSITORY>
	git push --mirror <DESTINATION_REPOSITORY_URL>


> 2014/02/20 09:59:23 更新

-------------

## DATAPUMP metadata_only

* DB-ORACLE-DATAPUMP

## メタ情報のエクスポート

	expdp hr/hr DIRECTORY=dpump_dir1 DUMPFILE=hr_comp.dmp COMPRESSION=METADATA_ONLY


2004/02/19 10:00:00 更新

-------------

