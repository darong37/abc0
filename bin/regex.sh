#!/bin/sh -u

typeset template="$( 
  cat <<'__TEMPLATE__'
#!{(.+)}
######################################################################
#@(#) Project        : EBS Version up Project
#@(#) Team           : Infrastructure
#@(#) Name           : {(.+)}
#@(#) Function       : {(.+)}
#@(#) Version        : v.{[.0-9]+}
#@(#) Usage          : {(.+)}
#@(#) Return code    : 
#@(#)                  0  : Successful completion.
#@(#)                  >0 : An error condition occurred.
#@(#) Host           : (AIX|HP-UX)
#@(#) ACL            : {(.+)}
#@(#) Relation file  : {?(.*)}
#@(#) Notes          : {
(?:.*\n)+
}
#@(#)
######################################################################
#@(#) Revision history
#@(#) Date             Developer/Corrector Description
#@(#) ________________ ___________________ ______________________
#@(#) {(.+)}
{
(?:.*
?)*
}
######################################################################
# Initialization
######################################################################
__TEMPLATE__
)"

echo "$template" |
while read regex;do
  echo "regex='\\Q${regex}\\E\\n'"
done
