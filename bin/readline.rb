#!/usr/local/ruby/bin/ruby
require 'readline'

while buf = Readline.readline("> ", true)
  print("-> ", buf, "\n")
end
