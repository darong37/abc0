

## データファイルの設定確認（事前）  

~~~~sql  
col TABLESPACE_NAME format a12  
col FILE_NAME format a40  
col next_MB for 999,999,999.99  
col size_MB for 999,999,999.99  
col maxsize_MB for 999,999,999.99  

select TABLESPACE_NAME  
       ,FILE_NAME  
       ,AUTOEXTENSIBLE  
       ,MAXBYTES/1024/1024    maxsize_MB  
       ,BYTES/1024/1024       size_MB  
       ,INCREMENT_BY*8/1024   next_MB  
from   DBA_DATA_FILES   
--where  tablespace_name not in ('UNDOTBS1')  
order  by tablespace_name;  

~~~~  


> 2014/03/27 15:42:50 更新

------------------



## TEMP容量確認  

~~~~sql  
set line 1000  
col TABLESPACE_NAME format a20  
col FILE_NAME       format a55  
col SIZE_MBYTES     for 99,999,990  
col MAXSIZE_MBYTES  for 99,999,990  

SELECT  
    TABLESPACE_NAME ,   
    FILE_NAME ,STATUS ,   
    BYTES/1024/1024 AS SIZE_MBYTES,  
    AUTOEXTENSIBLE,  
    MAXBYTES/1024/1024 AS MAXSIZE_MBYTES  
 FROM  
    DBA_TEMP_FILES ;   

~~~~  


> 2014/03/27 15:46:35 更新

------------------



## セッション情報  

~~~~sql  
col USERNAME for a8  
col SCHEMANAME for a8  
col PORT for 999999  
col TERMINAL for a16   
col TYPE for a12  
col PROGRAM for a40  
col STATUS for a8  
col MACHINE for a28  

select USERNAME,SCHEMANAME,PORT,TERMINAL,TYPE,PROGRAM,STATUS,MACHINE,LOGON_TIME from v$session order by type,username;  

~~~~  

> 2014/03/19 10:58:13 更新

------------------



## アラートログ等の出力先設定  

~~~~sql  
show parameter dest  


~~~~  

> 2014/03/19 09:56:58 更新

------------------



## テーブルスペースの使用状況確認  

~~~~sql  
col 表領域名 format a20  
col 現サイズ[MB] for 99,999,990  
col 使用容量[MB] for 99,999,990  
col 空き容量[MB] for 99,999,990  
col 使用率[％] for 990  
col 最大サイズ[MB] for 99,999,990  
col 最大空き容量[MB] for 99,999,990  
col 最大使用率[％] for 990  

SELECT   
    D.TABLESPACE_NAME                     AS "表領域名"  
  , D.SIZE_MB                             AS "現サイズ[MB]"  
  ,(D.SIZE_MB - F.FREE_MB)                AS "使用容量[MB]"  
  , F.FREE_MB                             AS "空き容量[MB]"  
  ,(1 - F.FREE_MB/D.SIZE_MB) * 100        AS "使用率[％]"  
  , D.MAX_MB                              AS "最大サイズ[MB]"  
  ,(D.MAX_MB - (D.SIZE_MB - F.FREE_MB))   AS "最大空き容量[MB]"  
  ,(1 - (D.MAX_MB - (D.SIZE_MB - F.FREE_MB))/D.MAX_MB) * 100   
                                          AS "最大使用率[％]"  
FROM (  
  SELECT   
    TABLESPACE_NAME  
  , SUM(BYTES)/1024/1024 AS SIZE_MB  
  , case  
      when AUTOEXTENSIBLE = 'YES'  
      then SUM(MAXBYTES)/1024/1024  
      else   SUM(BYTES)/1024/1024  
    end  AS MAX_MB  
  FROM  DBA_DATA_FILES  
  GROUP BY TABLESPACE_NAME,AUTOEXTENSIBLE  
) D,  
(
  SELECT   
    TABLESPACE_NAME  
  , SUM(BYTES)/1024/1024 AS FREE_MB  
  FROM  DBA_FREE_SPACE  
  GROUP BY TABLESPACE_NAME  
) F  
WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME  
order by D.TABLESPACE_NAME;  

~~~~  

> 2014/03/17 17:50:25 更新

------------------



## エクステンションマップ  

~~~~sql  
col tablespace_name for a12  
select tablespace_name from dba_tablespaces order by tablespace_name;  

break on FILE_ID skip page  
col segment for a40  
select  
  tablespace_name,   
  file_id,   
  block_id,   
  blocks,   
  owner||'.'||segment_name     segment   
from   
  dba_extents  
where  
  TABLESPACE_NAME = '&&TABLESPACE_NAME'  
union   
select   
  tablespace_name,   
  file_id,   
  block_id,   
  blocks,   
  '<free>'   
from   
  dba_free_space   
where  
  TABLESPACE_NAME = '&&TABLESPACE_NAME'  
order by 1,2,3;  

undefine TABLESPACE_NAME

~~~~  

> 2014/03/14 10:23:16 更新

------------------



## Packageのソースを取得する  

~~~~sql  
select distinct name from dba_source where TYPE ='PACKAGE' and name like '&name';  

select text from dba_source where TYPE ='PACKAGE' and name = '&name' order by line;  

select text from dba_source where TYPE ='PACKAGE BODY' and name = '&name' order by line;  


~~~~  

> 2014/03/12 18:22:25 更新

------------------



## パスワードがわからないユーザの期限切れを解除する  
sysdbaでsqlplus起動  

~~~~sql  
select NAME,PASSWORD from sys.user$ where name='&name';  

ALTER USER SYS IDENTIFIED BY VALUES '&PASSWORD';  

~~~~  

> 2014/03/12 16:10:36 更新

------------------


## テーブルカラムのコメント
  
~~~~sql
col COLUMN_NAME for a50
col COMMENTS for a80

select table_name from dictionary where table_name like '&table_name';

select COLUMN_NAME,COMMENTS 
from   DBA_COL_COMMENTS 
join   DBA_TAB_COLS using(TABLE_NAME,COLUMN_NAME) 
where  table_name = '&table_name' 
order  by COLUMN_ID;

~~~~

> 2014/03/12 13:05:46 更新

------------------



## sqlplusで結果をHTMLファイルに出力
  
~~~~sql
spool a.html
set markup html on 

select ; 

set markup html off 
spool off

host a.html --ブラウザでhtmlファイルを開きます。
  
~~~~

> 2014/03/12 11:40:33 更新

------------------



## sqlplus 起動
  
~~~~bash
  
export ORACLE_SID=prdcpf
sqlplus / as sysdba

~~~~

~~~~sql

set pagesize 2000
set line 200

col HOST_NAME for a20
select HOST_NAME,INSTANCE_NAME,STATUS from v$instance;
    -- HOST_NAME            INSTANCE_NAME                                    STATUS
    -- -------------------- ------------------------------------------------ ------------------------------------
    -- MEC-PRE3D0111        prdcpf                                           OPEN

~~~~

> 2014/03/11 11:01:16 更新

------------------



## viコマンド
  
区分        |コマンド|説明
------------|--------|------------------------------
カーソル移動|h       |左
カーソル移動|j       |下
カーソル移動|k       |上
カーソル移動|l       |右
カーソル移動|5l      |５文字右にカーソルを移動する
カーソル移動|Shift +g|ファイルの最後の行の先頭に移動
カーソル移動|gg      |ファイルの先頭に移動
カーソル移動|$       |行の最後に移動
カーソル移動|０ ゼロ |行の先頭に移動
カーソル移動|^       |行の最初の空白でない文字に移動
カーソル移動|G       |ファイルの末尾に移動
カーソル移動|Ctrl +f |ページアップ
カーソル移動|Ctrl +ｂ|ページダウン
カーソル移動|M       |カーソルを画面の中心に移動
File再読込  |:e!     |編集を破棄してFileの再読み込み
File保存    |:wq     |現在編集中の内容を元のファイルに書き込んで終了
File保存終了|:w      |編集結果を保存
ヘルプ      |:help +Enter|オンラインヘルプ表示
編集：UNDO  |u       |直前の編集状態に戻す
編集：検索  |/       |前方
編集：検索  |?       |後方
編集：検索  |n       |前方再検索
編集：検索  |N       |後方再検索
編集：削除  |x       |現在カーソルのある文字を削除
編集：削除  |3x      |現在カーソルのある文字を削除　カウントの使用
編集：削除  |X       |カーソル直前の文字を削除
編集：削除  |D       |カーソル以降を削除
編集：削除  |dw      |現在カーソルのある単語を削除
編集：削除  |Shift +d|カーソルから行末までを削除
編集：削除  |dd      |現在カーソルのある行を削除（カット）
編集：削除  |100dd   |現在カーソルのある行を削除　カウントの使用
編集：置換  |s/xxx/yyy/    |xxxをｙｙｙに置換
編集：置換  |:s/xxx/yyy/g  |カーソル行を全範囲として、xxxをyyyに置換
編集：置換  |:%s/xxx/yyy/g |ファイルを全範囲として、xxxをyyyに置換
編集：置換  |:%s/xxx/yyy/gc|ファイルを全範囲として、xxxをyyyに置換  確認しながら。
編集：ペースト|p       |カーソル行の下にペースト
編集：ペースト|3p      |カーソル行の下にペースト　バッファーが３回ペーストされる。
編集：ペースト|P       |カーソル行の上にペースト
編集：文字入力|i       |インサートモードになり、カーソルの前に文字列を挿入可能
編集：文字入力|a       |インサートモードになり、カーソルの後ろに文字列を挿入可能
編集：文字入力|o       |カーソル行の下に一行空白行を挿入
編集：文字入力|Shift + o|カーソル行の上に一行空白行を挿入
編集：文字入力|ESC     |インサートモードからコマンドモードに戻る
編集：文字入力|I       |カーソル行の先頭から入力開始
編集：文字入力|A       |カーソル行の末尾から入力開始
編集：文字入力|r       |カーソル上の文字を置換
編集：文字入力|R       |以降の入力を上書き状態
編集：文字入力|O       |カーソル行の上に一行空白行を挿入
編集：文字入力|J       |カーソル行と直下の行を連結
編集：ヤンク  |yy      |カーソル行をヤンク（コピー）
編集：ヤンク  |3yy     |カーソル行をヤンク（コピー）　カウントの使用
モードについて|起動直後|コマンドモード
モードについて|i       |コマンド　－＞　インサート　モード
モードについて|ESC     |インサート　－＞　コマンド　モード
モードについて|:       |コマンド　－＞　ｅｘラインエディタ　モード
モードについて|ESC     |ｅｘラインエディタ　－＞　コマンド　モード


> 2014/03/10 18:33:22 更新

------------------



## Teraterm でログインする
ログイン： oracle@MEC-PRE3D0111  

~~~~bash
whoami; id; hostname; date
	# oracle
	# uid=1100(oracle) gid=1000(oinstall) groups=1100(dba),1200(oper)
	# MEC-PRE3D0111
cd /oraapp/home
pwd
	# /oraapp/home

~~~~

> 2014/03/10 11:22:42 更新

------------------


## Windows Event Log ID
Start Log Service: 6005
Shutdown: 6006

> 2014/03/03 15:14:11 更新

------------------


## 未使用ブロック情報
~~~~sql
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

~~~~

> 2014/02/27 14:07:26 更新

------------------


## 表領域、データファイル一覧

~~~~sql
set pagesize 1000
set linesize 200
col TABLESPACE_NAME for a20
col FILE_NAME for a50
col MAXBYTES for 99999999999999
select tablespace_name, file_name, bytes/1024/1024 MBytes, autoextensible, maxbytes/1024/1024 MaxMBytes
from dba_data_files
order by tablespace_name, file_name ;

~~~~


> 2014/02/26 18:48:06 更新

------------------


## Msys bashの起動

	\.abc\.sys\bin\bash.exe --login -i -c

> 2014/02/26 11:33:49 更新

------------------


## ＤＤＬ文の取得
表「emp」のＤＤＬ文を取得

~~~~sql
set long 2000
set heading off

select
dbms_metadata.get_ddl('TABLE','EMP')
from dual;
~~~~

> 2014/02/26 11:05:03 更新

-------------

~~~~bash
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

~~~~


> 2014/02/21 16:09:03 更新

------------------

## Gitレポジトリを移行する方法

	git clone --mirror <SOURCE_REPOSITORY_URL>
	cd <REPOSITORY>
	git push --mirror <DESTINATION_REPOSITORY_URL>


> 2014/02/20 09:59:23 更新

-------------

## DATAPUMP metadata_only

* DB-ORACLE-DATAPUMP


	expdp hr/hr DIRECTORY=dpump_dir1 DUMPFILE=hr_comp.dmp COMPRESSION=METADATA_ONLY


> 2004/02/19 10:00:00 更新

-------------

## Perl Prompt


~~~~perl  
use Term::Prompt;  

	#my $ans = prompt('x', 'question', 'help', 'default' );  
my $ans = prompt('x', 'question ?','','' );  
printf "Ans: '$ans'\n";  

$ans = prompt('x', 'question ?','y/n','' );  
printf "Ans: '$ans'\n";  

$ans = prompt('x', 'question ?','y/n','y' );  
printf "Ans: '$ans'\n";  

$ans = prompt('x', 'question ?','','y' );  
printf "Ans: '$ans'\n";  

~~~~

> 2004/02/18 10:00:00 更新

