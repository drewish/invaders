# A view into the board.
class Tile
  attr_accessor :intersections, :paths, :type
  attr_reader :rgb

  def initialize(board, rgb)
    @board = board
    @rgb = rgb
    @intersections = {:n => nil, :nw => nil, :sw => nil, :s => nil, :se => nil, :ne => nil }
    @paths = {:nw => nil, :w => nil, :sw => nil, :se => nil, :e => nil, :ne => nil }
    @type = nil
  end
  
  def color
=begin
case target-expr
  when comparison [, comparison]... [then]
    body
  when comparison [, comparison]... [then]
    body
  end
=end
  end
end