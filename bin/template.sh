#!/usr/bin/ksh
typeset applsDir=$1
typeset fileName=$2
typeset option=$3

if [[ $option = '-trans' ]];then
	mkdir -p $applsDir/_recycle
	target=$applsDir/_recycle/$fileName.$( date +'%Y%m%d' )
	if [ -s $target ];then
		target=$applsDir/_recycle/$fileName.$( date +'%Y%m%d_%H%M%S' )
	fi
	cp -p $applsDir/$fileName $target
	if [ ! -e $applsDir/$fileName.org ];then
		cp -p $applsDir/$fileName $applsDir/$fileName.bak
	fi
fi

{
	cat <<-_ARGS_
		@prms = ( '$applsDir','${fileName%.trns}','$option' );
	_ARGS_
	cat <<-'_PERL_'
		( $applsDir,$fileName,$option ) = @prms;

		local $/ = undef;
		my $source = <>;

		$c = $source =~ s/\n/\n/g;
		print "\n";
		print "---- Source ----\n";
		print "$applsDir/$fileName\n";
		print "$c lines\n";

		if ( $option eq '-header' ){
			$headPtn = "#!(.+)
######################################################################
#@\\(#\\) Project        : EBS Version up Project
#@\\(#\\) Team           : Infrastructure
#@\\(#\\) Name           : (.+)
#@\\(#\\) Function       : (.+)
#@\\(#\\) Version        : v\\.([.0-9]+)
#@\\(#\\) Us[ae]ge          : (.+)
#@\\(#\\) Return code    : ?
#@\\(#\\)                  0  : Successful completion.
#@\\(#\\)                  >0 : An error condition occurred.
#@\\(#\\) Host           : (AIX|HP-UX)
#@\\(#\\) ACL            : (.+)
#@\\(#\\) Relation file  : ?(.*)
#@\\(#\\) Notes          : ?((?:.*
?)+)
#@\\(#\\)
######################################################################
#@\\(#\\) Revision history
#@\\(#\\) Date             Developer/Corrector Description
#@\\(#\\) ________________ ___________________ ______________________+
#@\\(#\\) (.+)
(?:.*
?)*
######################################################################
# Initialization
######################################################################
";
=comment
=cut

		} else {
			$headPtn = "#!(.+)
######################################################################
#@\\(#\\) Project        : EBS Version up Project
#@\\(#\\) Team           : Infrastructure
#@\\(#\\) Name           : (.+)
#@\\(#\\) Function       : (.+)
#@\\(#\\) Version        : v\\.([.0-9]+)
#@\\(#\\) Us[ae]ge          : (.+)
#@\\(#\\) Return code    : ?
#@\\(#\\)                  0  : Successful completion.
#@\\(#\\)                  >0 : An error condition occurred.
#@\\(#\\) Host           : (AIX|HP-UX)
#@\\(#\\) ACL            : (.+)
#@\\(#\\) Relation file  : ?(.*)
#@\\(#\\) Notes          : ?((?:.*
?)+)
#@\\(#\\)
######################################################################
#@\\(#\\) Revision history
#@\\(#\\) Date             Developer/Corrector Description
#@\\(#\\) ________________ ___________________ ______________________+
#@\\(#\\) (.+)
(?:.*
?)*
######################################################################
# Initialization
######################################################################
(?:.*
?)*
######################################################################
# (Define|Main Brace|Subroutine)
######################################################################
((.*
)+
?)\$";
		};

		if ( $source =~ /$headPtn/ ){
			( $whch,$flnm,$desc,$ver ,$usag,$host,$prmt,$rfil,$note,$hist,$def ,$code ) 
			= ( $1 ,$2   ,$3   ,$4   ,$5   ,$6   ,$7   ,$8   ,$9   ,$10  ,$11  ,$12   );
			print "\n";
			print "---- Header  ----\n";
			print "# Which Shell       : '$whch'\n";
			print "# Name              : '$flnm'\n";
			print "# Description       : '$desc'\n";
			print "# Version           : '$ver' \n";
			print "# Usage             : '$usag'\n";
			print "# Host              : '$host'\n";
			print "# Permition         : '$prmt'\n";
			print "# Relation file     : '$rfil'\n";
			print "# Notes             : '$note'\n";
			print "# History           : '$hist'\n";
			print "# Label             : '$def' \n";
			
			$c = $code =~ s/\n/\n/g;
			
			print "\n";
			print "---- Code    ----\n";
			print "$c lines \n";
			
			if ( $flnm ne $fileName ){
				print "\n";
				print "**** Caution ****\n";
				print "Unmatched Name\n";
				print "Correct it as the below.\n";
				print "#@(#) Name           : ${fileName}\n";
				
				$source =~ s/$flnm/$fileName/g;
				open( OUT,">${applsDir}/${fileName}.rpl" );
				print OUT $source;
				close(OUT);
				
				print "\n";
				print "Replaced ${fileName} \n";
				print "\n";
				$option='';
			};
		} else {
			print "# No match\n";
		};
		
		
		if ( $option eq '-trans' ){
#			if ( $def eq 'Main Brace' ){
#				print "\n";
#				print "Already Transfered\n";
#				exit;
#			};
		
			print "\n";
			print "---- Trans  ----\n";
			print "Translate -> ${fileName} \n";
			print "\n";
			print "# Rollback\n";
			print "# mv ${fileName}.bak ${fileName} \n";
			print "\n";

			open( OUT,">${applsDir}/${fileName}" );
			print OUT "#!/usr/bin/ksh -u
######################################################################
#@(#) Project        : EBS Version up Project
#@(#) Team           : Infrastructure
#@(#) Name           : ${fileName}
#@(#) Function       : ${desc}
#@(#) Version        : v.1.1.0
#@(#) Usage          : ${usag}
#@(#) Return code    :
#@(#)                  0  : Successful completion.
#@(#)                  >0 : An error condition occurred.
#@(#) Host           : AIX
#@(#) ACL            : ${prmt}
#@(#) Relation file  : ${rfil}
#@(#) Notes          : ${note}
#@(#)
######################################################################
#@(#) Revision history
#@(#) Date             Developer/Corrector Description
#@(#) ________________ ___________________ ___________________________
#@(#) 2013/04/01       E.Yoshida           New
######################################################################
";

			$tmplate = <<'__EOS__';

######################################################################
# Initialization
######################################################################
typeset APPLDIR=$( cd $(dirname $0) && pwd )
typeset BASEDIR='../..'                # ベースフォルダの  APPLDIRからの相対パス
typeset CONFDIR='scripts/ENV'          # 環境設定フォルダのBASEDIRからの相対パス
typeset DEFENVS='common.env'           # CONFDIR内の環境設定ファイル名,複数可(space区切)

if [ ! -r $APPLDIR/$BASEDIR/$CONFDIR/DefEnv ];then
  typeset _FMTMSG="[UNYO] [%s] [$(uname -n)] [%-11s] [%04d] [%8d,%8d] [${_SIGNATURE:-$(basename $0)}] [%s #%03d]"
  _SAYMSG () { printf "$_FMTMSG" "$(date +'%Y/%m/%d %H:%M:%S')" "${3:-Fatal}" ${4:-9999} $$ $PPID "$2" $1 ; }
  typeset MSG=$( _SAYMSG $LINENO 'can not read DefEnv' )
  echo   "#!! $MSG"
  logger -i -t "$(/usr/bin/id -un)" "$MSG"
  exit 99
fi

. $APPLDIR/$BASEDIR/$CONFDIR/DefEnv

######################################################################
# Main Brace
######################################################################
cd  $WRK_DIR
{
  Info "start  Log : $LOGFILE"
  
  ##
  # Constants & Alias
  #
# readonly  RMT_SUBSCR="$BASEDIR//sub_.sh"
# readonly  LCL_SUBSCR="$BASEDIR//sub_.sh"

# readonly  RMT_CMDS_1=$(
#	cat <<-_REMOTE_COMMANDS_
#		${GBL_KSH_R} "${RMT_SUBSCR}" "${_SID}" 2>&1; 
#		echo  "# Return-code: \$?"
#	_REMOTE_COMMANDS_
# )

# readonly  HOSTNAME=$(uname -n)

# alias evlCheckSwitch=$(
#	cat <<-'_CMD_'
#		printf "su - '%s' -c 'jobs; /usr/bin/true' >&-"
#	_CMD_
# )
# alias evlSvrLstData=$(
#	cat <<-'_CMD_'
#		printf "egrep ',%s,%s$' ${PRJ_SERVER_LIST_FILE}"
#	_CMD_
# )

  ##
  # Init Check
  #
  [[ $(id -u)  -eq 0 ]]                || Die  "$(id -un) can not run (root only)"       1
# [[ $(id -un) = ora[a-z][0-9][0-9][0-9] ]]    \
#                                      || Die  "$(id -un) can not run (ora* only)"       1
# [[ $(id -gn) -eq ${_GRPNAM} ]]       || Die  "group $(id -gn) can not execute"         1
# [[ $SRVMODE = 'PRO' ]]               || Die  "allowed to run on PRO Env only"          1
# [[ $SRVROLE = 'DB' ]]                || Die  "not allowed to run on Non-DbServer"      1
# 
# ! hasStarted_DB                      && Die  "need to start Oracle DB."                1
# hasStarted_EBS                       && Die  "need to stop EBS & Concurrent Mgr."      1


  ##
  #  Arguments & Variables
  #
  (( $# == 1 ))                        || Die  "script requires 1 argument only"         2
  typeset _SID="${1:-}"
  [[ "${_SID}" = [a-z][0-9][0-9][0-9] ]]  \
                                       || Die  "invalid SID specified"                   2

  # Var
# typeset -i _RETALL=0                 ## 0 : All Green

  ## snippet - get another Server name
# typeset _RMTHOST                     ## DB Server of Disaster Environment ( ALT DB )
# typeset -i _cnt=$( eval $( evlSvrLstData ALT DB ) | wc -l )
# (( _cnt == 0 ))                      && Die  "unregistered ALT DB Server"              2
# (( _cnt != 1 ))                      && Die  "duplicate to register ALT DB Server"     2
# _RMTHOST=$( eval $( evlSvrLstData ALT DB ) | cut -d, -f1 )


  ##
  # Procedures
  #
  
  ## snippet - ping
# fa_check_ping "${_RMTNODE}"          || Die  "no response: ${_RMTNODE}"                3


  ## snippet - use temporary file
# touch  "${TMPFILE}"                  || Die  "can not write temporary file ${TMPFILE}" 4
#                                      ## uses as Remote result file

  ## snippet - remsh
# ${GBL_REMSH} "${_RMTNODE}" -n "${RMT_CMDS_1}" > ${TMPFILE} 2>&1           \
#                                      || Die  "remsh failed"                            5
# [[ -s "${TMPFILE}" ]]                || Die  "lost remote result"                      6
#
# Info "remote run ${RMT_SUBSCR##*/} on ${_RMTNODE}"  7
# cat ${TMPFILE}
# tail -1 "${TMPFILE}" | grep -sq '^# Return-code: 0$'  \
#                                      || Die  "failed remote ${RMT_SUBSCR##*/}"         7

  ## snippet - check all
# (( _RETALL == 0 ))                   || Die  "faild some remsh"


  ##
  # Final
  #

  # if used temporary file
  # rm "${TMPFILE}"                    || Warn "can not remove temporary-file"

  Info "finish" 0 -syslog
} >> $LOGFILE 2>&1

# Copy to Historical Log if needed.
cp -p $LOGFILE $LOGHIST                || Warn "can not copy historical-log"

exit

#################
__EOS__

			print OUT $tmplate;
			
			print OUT $code;
			
			close(OUT);
		};
		exit;
		__DATA__
	_PERL_
	cat $applsDir/$fileName
} | perl ''

if [ -e $applsDir/$fileName.rpl ];then
	cp -p  $applsDir/$fileName  $applsDir/$fileName.org
	mv $applsDir/$fileName.rpl  $applsDir/$fileName
fi
