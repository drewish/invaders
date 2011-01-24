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
      [0.7686, 0.3804, 0.2902]
    when :desert
      [0.9686, 0.8745, 0.6745]
    when :ore
      [0.3098, 0.3098, 0.2824]
    when :grain
      [0.949, 0.7569, 0.2941]
    when :lumber
      [0.3608, 0.4784, 0.1843]
    when :wool
      [0.7255, 0.8314, 0.3255]
    else
      [0, 0, 0]
    end
  end
end