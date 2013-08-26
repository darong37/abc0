#!/usr/local/ruby/bin/ruby
require 'rubygems'
require 'active_support/core_ext'
require 'readline'
require 'net/telnet'
require 'io/console'

require 'pry'

#
class Term < Net::Telnet
  def cmds(options)
    if options.kind_of?(Hash)
      if block_given? 
        login(options){ |c| yield c }
      else
        login(options)
      end
    else
      if block_given? 
        cmd(options){ |c| yield c }
      else
        cmd(options)
      end
    end
  end
end

class Keyboad
  attr_accessor :sfil, :cmds, :rtns
  def initialize
    @sfil = ''
    @cmds = []
    @rtns = []
  end
  
  def read
    src = File.open(@sfil).read
    src.gsub!(/^[ \t\n]+/,'')            # 先頭スペース
    src.gsub!(/[ \t\n]+$/,'')            # 終端スペース
    src = "\n#{src}\n"                   # 先頭終端改行付加
    src.gsub!(/(?<=\n)###+\n/,'')
    src.gsub!(/(?<=\n)\s*\n/,'')
    src.gsub!(/(?<=\n)[#>\$]\s*\n/,'')
    src.gsub!(/^\n/,'')                  # 先頭改行削除
    src.gsub!(/\n$/,'')                  # 終端改行削除
#   src.gsub!(/(?<=\n)([#>\$])/,"\n\\1")
    src.gsub!(/(?<=\n)([#>\$])/){"\n#{$1}"}
    
#   print "'#{src}'\n"
    for blk in src.split(/\n\n/)
      if blk =~ /^#\@/
        host = blk.scan(/^#\@host: (.+)\s*$/)[0] if blk =~ /^#\@host: /
        user = blk.scan(/^#\@user: (.+)\s*$/)[0] if blk =~ /^#\@user: /
        
      end
    end
  end
end


stxt = Keyboad.new

#stxt.file = '/c/Users/JKK0544/.abc/logs/oper/20130813/20130813-001_oracle-check-tablespaces-size_orae058@mecerp3x0111.txt'
stxt.sfil = 'c:\Users\JKK0544\.abc\logs\oper\20130813\20130813-001_oracle-check-tablespaces-size_orae058@mecerp3x0111.txt'
stxt.read

exit

#
host,user,pswd = ARGV

host ||= 'mecerp3x0111'
user ||= 'root'

if pswd.blank? then
  pswd = STDIN.noecho(&:gets)
end


# リモートホスト
# タイムアウトは 3 秒
telnet = Term.new(
  "Host"       => host,
  "Prompt"     => /[$%#>]\z/n,
  "Output_log" => 'telnet.log',
  "Timeout"    => 3
)

# ログインし、プロンプトが出るまで待ち合わせる
cmd = { "Name"=>user, "Password"=>pswd }

# REPL
begin
  telnet.cmds(cmd) { |c|
    print c
  }
  STDOUT.flush  # <- これがないとここまで処理が来てることがわかりにくい
rescue
  STDOUT.flush
  prmpt = "rescue> "
else
  prmpt = " "
end while cmd = Readline.readline(prmpt, true)

# ログインセッションの終了
telnet.close

