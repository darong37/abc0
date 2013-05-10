#!/usr/bin/perl -nl
use strict;
use warnings;

# ファイルパーミッションに関する定数をインポート
use Fcntl ':mode';

s/\s+$//;
s/^.+\s+//;
s/\*$//;

#printf "%-20s\t", $_;

# stat関数の戻り値の3つ目の要素がファイル
# パーミッションの情報
my @sts = stat;

#localtimeで現地時間に変換
my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($sts[9]);

# 所有者ユーザID(数値)からユーザ名を取得する
my $uname = getpwuid $sts[4];

# 所有グループID(数値)からグループ名を取得する
my $gname = getgrgid $sts[5];

# cksum
my $chk = '';

if ( S_ISREG($sts[2]) ) {
	$chk = `cksum $_` ;
	chomp $chk;
	$chk =~ s/\s+\S+$//;
	$chk =~ s/\s+/\t/;
};

# S_IMODE関数で数値に変換
printf "%-20s\t%03o\t%s\t%s\t%04d/%02d/%02d %02d:%02d:%02d\t$chk\n", $_, S_IMODE($sts[2]), $uname, $gname, $year+1900, $mon+1, $mday, $hour, $min, $sec;
#printf "%03o\t%s\t%s\t%04d/%02d/%02d %02d:%02d:%02d\t$chk\n", S_IMODE($sts[2]), $uname, $gname, $year+1900, $mon+1, $mday, $hour, $min, $sec;

