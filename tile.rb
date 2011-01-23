# A view into the board.
class Tile
  attr_accessor :intersections, :paths
  attr_reader :rgb, :type, :roll

  def initialize(board, rgb, type, roll)
    @board = board
    @rgb = rgb
    @intersections = {:n => nil, :nw => nil, :sw => nil, :s => nil, :se => nil, :ne => nil }
    @paths = {:nw => nil, :w => nil, :sw => nil, :se => nil, :e => nil, :ne => nil }
    @type = type
    @roll = roll
  end
  
  def color
    case @type
    when :brick
      [0.855, 0.400, 0.271]
    when :desert
      [0.93, 0.91, 0.67]
    when :ore
      [0.4, 0.4, 0.4]
    when :grain
      [1.0, 1.0, 0.4]
    when :lumber
      [0.2, 0.4, 0.0]
    when :wool
      [0.4, 0.6, 0.0]
    else
      [0, 0, 0]
    end
  end
end