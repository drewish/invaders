require 'observer'

class Player
  include Observable


  attr_reader(:name, :color, :resources)

  def initialize(board, name, color) 
    @board, @name, @color = board, name, color
    @resources = {:brick => 0, :grain => 0, :lumber => 0, :ore => 0, :wool => 0}
    @active = false
    @purchases = []
  end

  def inspect
    "<Player #{@name} color: #{@color} score: {score} resources: #{@resources}>"
  end

  def afford?(resources)
    resources.all? { | type, ammount | ammount <= @resources[type] }
  end
  
  def pay_for(item)
puts "pay for: " + item.to_s
    @purchases << item
  end
  
  def active?
    @active == true
  end
  
  def active=(value)
    return if @active == value

    changed
    @active = !!value
    notify_observers self, :changed
  end
  
  def score
    @purchases.inject(0) do | total, item | 
      total += case item
      when Path 
        1
      when Intersection
        case item.type 
        when :settlement then 1
        when :city then 2
        else 0
        end
      else
        0
      end
    end
  end
end