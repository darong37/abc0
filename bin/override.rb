#!/usr/bin/env ruby
class Car
  def accele
    print("accele on\n")
  end
end

class Soarer < Car
  def accele
    super
    print("gyuuum \n")
  end
end

soarer = Soarer.new
soarer.accele


soarer = Soarer.new
soarer.accele
