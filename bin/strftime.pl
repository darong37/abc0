use POSIX 'strftime';

my $now = strftime "%Y/%m/%d %H:%M:%S", localtime;
print $now, "\n";
