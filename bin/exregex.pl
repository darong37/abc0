#!/bin/perl
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

use FindBin;
use lib "$FindBin::Bin";
use eyos;
####

$Term::ANSIColor::AUTORESET = 0;
print RESET;

my $target = adjust('	',<<'EOS','off');

	LSNRCTL for IBM/AIX RISC System/6000: Version 11.2.0.3.0 - Production on 30-JUL-2013 15:31:29

	Copyright (c) 1991, 2011, Oracle.  All rights reserved.

	Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1576)))
	STATUS of the LISTENER
	------------------------
	Alias                     e058
	Version                   TNSLSNR for IBM/AIX RISC System/6000: Version 11.2.0.3.0 - Production
	Start Date                26-JUL-2013 15:21:07
	Uptime                    4 days 0 hr. 10 min. 21 sec
	Trace Level               off
	Security                  ON: Local OS Authentication
	SNMP                      ON
	Listener Parameter File   /u45/e058/oracle/db/tech_st/11.2.0/network/admin/listener.ora
	Listener Log File         /u45/e058/oracle/db/tech_st/11.2.0/network/log/e058.log
	Listening Endpoints Summary...
	  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1576)))
	  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=mecerp3x0111.in.mec.co.jp)(PORT=1576)))
	Services Summary...
	Service "e058.in.mec.co.jp" has 2 instance(s).
	  Instance "e058", status UNKNOWN, has 1 handler(s) for this service...
	  Instance "e058", status READY, has 1 handler(s) for this service...
	Service "e058XDB.in.mec.co.jp" has 1 instance(s).
	  Instance "e058", status READY, has 1 handler(s) for this service...
	The command completed successfully
EOS

my $pattern = adjust('	',<<'EOS','off');

	LSNRCTL for IBM/AIX RISC System/6000: Version 11.2.0.3.0 - Production on 18-JUL-2013 16:08:18

	Copyright (c) 1991, 2011, Oracle.  All rights reserved.

	Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=mecerp3x0111.in.mec.co.jp)(PORT=1572)))
	STATUS of the LISTENER
	------------------------
	Alias                     E001
	Version                   TNSLSNR for IBM/AIX RISC System/6000: Version 11.2.0.3.0 - Production
	Start Date                18-JUL-2013 15:13:48
	Uptime                    0 days 0 hr. 54 min. 30 sec
	Trace Level               off
	Security                  ON: Local OS Authentication
	SNMP                      ON
	Listener Parameter File   /u43/e001/oracle/db/tech_st/11.2.0/network/admin/listener.ora
	Listener Log File         /u43/e001/oracle/diag/tnslsnr/mecerp3x0111/e001/alert/log.xml
	Listening Endpoints Summary...
	  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=mecerp3x0111.in.mec.co.jp)(PORT=1572)))
	  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1572)))
	Services Summary...
	Service "e058.in.mec.co.jp" has 2 instance(s).
	{:}
	The command completed successfully

EOS

print "\n\n-- target   --\n";
print "'$target'";
print "\n--";

print "\n\n-- pattern --\n";
print "'$pattern'";
print "\n--";

my $result = exregex($pattern,$target,1);

print "\n\n-- results  --\n";

print "'$result'";

exit;

### adjust
sub adjust {
  my ( $indent,$doc,$eos ) = @_;
  #
  $doc =~ s/^$indent//g;
  $doc =~ s/\n$indent/\n/g;
  if ( $eos eq 'off' ){
    $doc =~ s/\n$//;
  }
  return $doc;
}
