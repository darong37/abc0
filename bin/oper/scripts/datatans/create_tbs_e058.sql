CREATE TABLESPACE "APPS_TS_ARCHIVE" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_archive01.dbf' SIZE 786432000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_archive02.dbf' SIZE 786432000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_INTERFACE" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_int01.dbf' SIZE 891289600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_int02.dbf' SIZE 891289600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_int03.dbf' SIZE 891289600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_int04.dbf' SIZE 891289600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_MEDIA" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_media01.dbf' SIZE 1400M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_media02.dbf' SIZE 1200M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_NOLOGGING" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_nolog01.dbf' SIZE 167772160 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_QUEUES" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_queue01.dbf' SIZE 524288000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_queue02.dbf' SIZE 524288000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_SEED" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_ref01.dbf' SIZE 1500M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_ref02.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_ref03.dbf' SIZE 1500M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_ref04.dbf' SIZE 1500M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_ref05.dbf' SIZE 1500M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_ref06.dbf' SIZE 1500M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_SUMMARY" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_summ01.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_summ02.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_summ03.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_TX_DATA" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_txn_data01.dbf' SIZE 1100M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data02.dbf' SIZE 1100M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data03.dbf' SIZE 1200M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data04.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data05.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data06.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data07.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data08.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data09.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_data10.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "APPS_TS_TX_IDX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/a_txn_ind01.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind02.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind03.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind04.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind05.dbf' SIZE 786432000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind06.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind07.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind08.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind09.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/a_txn_ind10.dbf' SIZE 1048576000 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "CTXD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/ctxd01.dbf' SIZE 230686720 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "ODM" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/odm.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "OLAP" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/olap.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "OWAPUB" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/owad01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "PORTAL" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/portal01.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING SEGMENT SPACE MANAGEMENT AUTO
CREATE TABLESPACE "XGVD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xgvd01.dbf' SIZE 178257920 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XGVX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xgvx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xgvx02.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXAND" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxand01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXANX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxanx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXAPD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxapd01.dbf' SIZE 1190M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxapd02.dbf' SIZE 1038090240 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxapd03.dbf' SIZE 1038090240 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXAPX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxapx01.dbf' SIZE 41943040 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXARD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxard01.dbf' SIZE 136314880 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXARX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxarx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXBSMD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxbsmd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXBSMX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxbsmx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXCED" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxced01.dbf' SIZE 41943040 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXCEX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxcex01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXDIVD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxdivd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXDIVX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxdivx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXFFAD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxffad01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXFFAX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxffax01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXFNDD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxfndd01.dbf' SIZE 555745280 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxfndd02.dbf' SIZE 555745280 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxfndd03.dbf' SIZE 555745280 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXFNDX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxfndx01.dbf' SIZE 20971520 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXGLD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxgld01.dbf' SIZE 440401920 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxgld02.dbf' SIZE 440401920 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXGLX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxglx01.dbf' SIZE 83886080 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXHSD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxhsd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxhsd02.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXHSX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxhsx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJBDD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjbdd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJBDX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjbdx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJHID" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjhid01.dbf' SIZE 1140M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxjhid02.dbf' SIZE 1140M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxjhid03.dbf' SIZE 1140M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJHIX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjhix01.dbf' SIZE 461373440 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJSKD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjskd01.dbf' SIZE 2000M REUSE, '/u11/e058/oracle/e058data/xxjskd02.dbf' SIZE 209715200 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxjskd03.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxjskd04.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJSKX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjskx01.dbf' SIZE 566231040 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxjskx02.dbf' SIZE 566231040 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJSMD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjsmd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJSMX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjsmx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJTDD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjtdd01.dbf' SIZE 62914560 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXJTDX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxjtdx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXKFD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxkfd01.dbf' SIZE 31457280 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXKFX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxkfx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXKSMD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxksmd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXKSMX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxksmx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXLED" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxled01.dbf' SIZE 314572800 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXLEX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxlex01.dbf' SIZE 52428800 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXMD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxmd01.dbf' SIZE 94371840 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXMX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxmx01.dbf' SIZE 41943040 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPA_WEBD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpa_webd01.dbf' SIZE 136314880 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPA_WEBX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpa_webx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPAD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpad01.dbf' SIZE 975175680 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxpad02.dbf' SIZE 975175680 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxpad03.dbf' SIZE 975175680 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPAX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpax01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPND" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpnd01.dbf' SIZE 115343360 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPNX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpnx01.dbf' SIZE 20971520 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPOD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpod01.dbf' SIZE 230686720 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPOND" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpond01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPONX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxponx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXPOX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxpox01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXSVFD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxsvfd01.dbf' SIZE 115343360 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXSVFX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxsvfx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXTRD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxtrd01.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxtrd02.dbf' SIZE 104857600 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXTRX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxtrx01.dbf' SIZE 199229440 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXWK" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxwk01.dbf' SIZE 1960M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M, '/u11/e058/oracle/e058data/xxwk02.dbf' SIZE 1960M REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXYOSD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxyosd01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "XXYOSX" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/xxyosx01.dbf' SIZE 10485760 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "FFAD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/ffad01.dbf' SIZE 268435456 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT DICTIONARY  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "STASTBS" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/stattbs01.dbf' SIZE 461373440 REUSE AUTOEXTEND ON NEXT 10485760  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  AUTOALLOCATE  ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "INTERIM" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/interim.dbf' SIZE 209715200 REUSE AUTOEXTEND ON NEXT 104857600  MAXSIZE 2000M EXTENT MANAGEMENT LOCAL  UNIFORM SIZE 131072 ONLINE PERMANENT  NOLOGGING
CREATE TABLESPACE "APPLSYSD" BLOCKSIZE 8192 DATAFILE  '/u11/e058/oracle/e058data/applsysd01.dbf' SIZE 2000M REUSE, '/u11/e058/oracle/e058data/applsysd02.dbf' SIZE 2000M REUSE EXTENT MANAGEMENT LOCAL  USER  DEFAULT NOCOMPRESS  STORAGE(INITIAL 40960 NEXT 40960 MINEXTENTS 1 MAXEXTENTS 505 PCTINCREASE 50) ONLINE PERMANENT  NOLOGGING
GRANT CREATE TABLESPACE TO "SYS"
