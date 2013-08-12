#!/usr/local/ruby/bin/ruby
require 'readline'
require 'net/telnet'

host,user,psw = ARGV

host ||= 'mecerp3x0111'
user ||= 'root'

if psw.blank? then
  psw = STDIN.noecho(&:gets)
end

# リモートホスト
# タイムアウトは 10 秒
telnet = Net::Telnet.new(
  "Host"       => host,
  "Prompt"     => /[$%#>]\z/n,
  "Output_log" => nil
  "Timeout"    => 3
)

# ログインし、プロンプトが出るまで待ち合わせる
telnet.login(
  root, 
  psw
) { |c| print c }






# ls コマンドを実行し、実行後、プロンプトが出るまで待ち合わせる
telnet.cmd("ls") {|c|
  print c
}

# sleep で 5 秒
telnet.cmd("sleep 5 && echo foobar &") {|c| print c}

STDOUT.flush # <- これがないとここまで処理が来てることがわかりにくい

# 前のコマンドの出力を待ち合わせる
telnet.waitfor(/foobar\Z/) {|c| print c}

# ログインセッションの終了
telnet.cmd("exit") {|c| print c}
telnet.close
