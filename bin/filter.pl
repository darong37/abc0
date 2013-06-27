#!/usr/bin/perl -nl
use strict;
use warnings;

# ファイルパーミッションに関する定数をインポート
use Fcntl ':mode';

s/#.+$//;        # コメントを削除
s/\s+$//;        # 後ろのスペース等を削除
s/^.+\s+//;      # 最後のスペース以降をファイル名として残す
s/\*$//;         # 最後の'*'を除去

next if /^\s*$/;        # スペース、空行をスキップ
next if /^_recycle$/;   # トップの_recycleをスキップ
next if /^_recycle\//;  # トップの_recycle内をスキップ
next if /\/_recycle$/;  # _recycleをスキップ
next if /\/_recycle\//; # _recycle内をスキップ


# stat関数の戻り値の3つ目の要素がファイル
# パーミッションの情報
my @sts = stat;

# 所有者ユーザID(数値)からユーザ名を取得する
my $uname = getpwuid $sts[4];

# 所有グループID(数値)からグループ名を取得する
my $gname = getgrgid $sts[5];


# Sizeを取得する
my $siz = $sts[7];


# cksum
my $chk = '';

if ( S_ISREG($sts[2]) ) {
  #localtimeで現地時間に変換
  my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($sts[9]);

  $chk = `cksum $_` ;
  chomp $chk;
  $chk =~ s/ .+$//;
  
  my $flp = $_;
  $flp =~ s{^[^/ ]+/}{./};

  # パーミッションをS_IMODE関数で数値に変換
  printf "%-50s\t#\t%03o \t%-8s\t%-8s\t%04d/%02d/%02d %02d:%02d:%02d \t%8d\t%s\n"
    , $flp, S_IMODE($sts[2]), $uname, $gname, $year+1900, $mon+1, $mday, $hour, $min, $sec, $siz, $chk;
#		    , $_, S_IMODE($sts[2]), $uname, $gname, $year+1900, $mon+1, $mday, $hour, $min, $sec, $siz, $chk;
} else {
  $_ = "$_/" unless /\/$/;
  
  # トップフォルダ（例：scripts）は可変なので置換
  my $flp = $_;
  $flp =~ s{^[^/ ]+/}{./};

  # パーミッションをS_IMODE関数で数値に変換
  printf "%-50s\t#\t%03o \t%-8s\t%s\n"
    , $flp, S_IMODE($sts[2]), $uname, $gname;
#		    , $_, S_IMODE($sts[2]), $uname, $gname;
};
