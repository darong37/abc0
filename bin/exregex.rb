#!/usr/bin/env ruby
require 'rubygems'
require 'active_support/core_ext'

require 'pry'
require 'debugger'

require 'term/ansicolor'

##
class Exs
  attr_accessor :org, :reg, :fmt
  def initialize (str)
    @org = str
  end
end

class Exregex
  attr_accessor :dbg
  def initialize
    @dbg  = 1;
    @orgs = []
    @regs = []
    @fmts = []
    
    @hash = { 
      '*'   => '(.*?)', 
      ':'   => '((?:.*\n)+?)',
      '_'   => '((?:\s*\n)*)',
      'num' => '([0-9]+)',
      'dat' => '([0-3 ][0-9]-(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-20[01][0-9]))',
      'tim' => '([0-2 ][0-9]:[0-5][0-9]:[0-5][0-9])',
    }
    
    @ptn_ex = ''
    @ptn_ex = ''
    @ptn_ex << Regexp.quote('{(')
    @ptn_ex << '([^\n]+?)'
    @ptn_ex << Regexp.quote(')}')
    
  end
  #
  # expush
  #
  def expush (str,excase)
    case excase
    # reg-key
    when 1
      org = "{(#{str})}"
      if @hash.key? str
        reg = @hash[str]
      else
        reg = "(#{str})"
      end
      fmt = '%s'
    # reg-''
    when 2
      org = "\n"
      reg = @hash['_']
      fmt = '%s'
    # reg-{(key)}
    when 3
      org = "#{str}\n"
      key = str.sub(/^\{\(/,'').sub(/\)\}$/,'')
      if @hash.key? key
        reg = @hash[key]
      else
        reg = "(#{key})"
      end
      fmt = '%s'
    # non-reg
    else
      org = str
      reg = Regexp.quote(str)
      fmt = str
    end
    #
    @orgs.push org
    @regs.push reg
    @fmts.push fmt
    
    if @dbg == 1
      p org
      print  "       ";p fmt
      printf "       '%s'\n",reg
    end
  end
  private :expush
  #
  # regex
  #
  def regex (exreg)
    exreg.sub!(/^[\s\n]*\n/   ,'')       # 先頭スペース
    exreg.sub!(/[\s\n]+$/     ,"\n")     # 終端スペース
    
    exreg.gsub!(/(?<=\n)\s*\n/,"\n")     # 空行スペース除去
    exreg.gsub!(/\n\n+/       ,"\n\n")   # 複数空行除去
    
    exreg.sub!(/\n$/,'')
    
    #
    exreg.split(/\n/).each_with_index do | line,idx_line |
      case line
      when ''
        printf "%02d,%d : ",idx_line,0 if @dbg == 1
        expush(line,2)
      when /^#{@ptn_ex}$/
        printf "%02d,%d : ",idx_line,0 if @dbg == 1
        expush(line,3)
      else
        # 0 or 1
        line.split(/(?:#{@ptn_ex})/).each_with_index do | ele,idx_ele |
          printf "%02d,%d : ",idx_line,idx_ele if @dbg == 1
          expush(ele,idx_ele%2)
        end
        printf "%02d,%s : ",idx_line,'E' if @dbg == 1
        expush("\n",0)
      end
    end
    expush("\n",0) if @regs[-1] != '\n'
  end
  #
  # eval
  #
  def eval (target)
    orga = []
    rega = []
    fmta = []
    (1..@regs.size).to_a.zip(@regs,@fmts,@orgs).each do | idx,reg,fmt,org |
      print "#{idx}\n"
      rega.push reg
      fmta.push fmt
      orga.push org
      #
      binding.pry
      if reg == '\n'
        regl = rega.join('')
        if target =~ Regexp.compile( regl )
          fmtl = fmta.join('')
          target = colorprint(target,fmtl,regl)
        else
          rega.zip(fmta).each do | reg,fmt |
            if reg !~ /^\(.+\)$/
              target = colorprint(target,fmt,reg)
            end
          end
        end
        orga = []
        rega = []
        fmta = []
      end
    end
  end
  #
  # colorprint
  #
  class String
     include Term::ANSIColor
  end
  class Color
    extend Term::ANSIColor
  end
  def colorprint (target,fmt,reg)
    print "cp1 '#{target.size}'\n" if @dbg == 1
    if target =~  Regexp.compile("^#{reg}")
      eles = target.scan(Regexp.compile("^#{reg}((?:.|\n)*)$"))
      target = eles.pop
    print "cp1-1 '#{target.size}'\n" if @dbg == 1
      eles.map!{ |ele| ele.green }
      
      print  Color.blue
      printf fmt,eles
      print  Color.clear
    else
      eles = target.scan(Regexp.compile("^((?:.|\n)*?)#{reg}((?:.|\n)*)$"))
      target = eles.pop
    print "cp1-2 '#{target.size}'\n" if @dbg == 1
      prev = eles.shift
      eles.map!{ |ele| ele.green }
      
      print  Color.red
      printf prev
      print  Color.clear
      
      print  Color.blue
      printf fmt,eles
      print  Color.clear
    end
    return target
  end
end

##
er = Exregex.new
er.regex( '''
LSNRCTL for IBM/AIX RISC System/6000: Version {([0-9.]+)} - Production on 18-JUL-2013 {(tim)}

Copyright (c) 1991, 2011, Oracle.  All rights reserved.


Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=mecerp3x0111.in.mec.co.jp)(PORT=1572)))
STATUS of the $LISTENER
------------------------
Alias                     E001
Version                   TNSLSNR for IBM/AIX RISC System/6000: Version {([0-9.]+)} - Production
Start Date                18-JUL-2013 15:13:48
Uptime                    0 days 0 hr. 54 min. 30 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      ON
Listener Parameter File   {(*)}
Listener Log File         /u43/e001/oracle/diag/tnslsnr/mecerp3x0111/e001/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=mecerp3x0111.in.mec.co.jp)(PORT=1572)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1572)))
Services Summary...
Service "e058.in.mec.co.jp" has 2 instance(s).
{(:)}
The command completed successfully
''' )

er.eval( '''
LSNRCTL for IBM/AIX RISC System/6000: Version 11.2.0.3.0 - Production on 30-JUL-2013 15:31:29

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1576)))
STATUS of the $LISTENER
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
''' )

