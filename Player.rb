class Player
  attr_reader(:color, :resources)

  def initialize(board, color) 
    @board, @color = board, color
    @resources = {:brick => 0, :grain => 0, :lumber => 0, :ore => 0, :wool => 0}
  end

  def pay(amounts)
    puts "paying for: " + amounts
  end

  def pay_for(type)
    puts "paying for "
    case type
      when :settlement
        #subtract some stuff
        pay({:brick => 1, :lumber => 1, :wool => 1, :grain => 1})
        return true
    
      when :city
        #subtract some stuff
        return true

      else
        false
    end
  end
end