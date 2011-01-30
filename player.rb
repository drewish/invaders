require 'observer'

class Player
  include Observable

  COSTS = {
    :road => {:brick => 1, :lumber => 1},
    :settlement => {:brick => 1, :lumber => 1, :grain => 1, :wool => 1},
    :city => {:grain => 2, :ore => 3},
    :development_card => {:wool => 1, :grain => 1, :ore => 1},
  }
  attr_reader(:name, :color, :resources)

  def initialize(board, name, color) 
    @board, @name, @color = board, name, color
    @resources = {:brick => 0, :grain => 0, :lumber => 0, :ore => 0, :wool => 0}
  end

  def inspect
    "<Player #{@name} color: #{@color}\nresources: #{@resources}>"
  end

  def pay_for(type)
    puts "paying for " + type.to_s + "  " + COSTS[type].inspect
    COSTS[type]
  end
end