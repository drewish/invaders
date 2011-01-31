require 'observer'

class Dice
  include Observable
  
  attr_reader :count, :faces, :values
  
  def initialize(count, faces = 6)
    @count, @faces = count, faces
    roll
  end

  def roll
    @values = (0...@count).collect { rand(@faces) + 1 }
    changed
    notify_observers self, :rolled
  end
end