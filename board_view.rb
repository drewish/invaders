require 'opengl'
include Gl,Glu,Glut

require 'board'
require 'base_view'
require 'intersection_view'
require 'path_view'
require 'tile_view'

class BoardView < BaseView
  def initialize(board)
    super
    @board = board
    @board.add_observer(self)
    
    @board.tiles.each_value { | o | @render_list << TileView.new(o) }
    @board.intersections.each_value { | o | @render_list << IntersectionView.new(o) }
    @board.paths.each_value { | o | @render_list << PathView.new(o) }
  end

  def render_hex_lines(s)
    glBegin(GL_LINES)

    w = s * 10
    h = s * 10

    # Vertical lines
    xoffset = Math.cos(Math::PI / 6) * s
    (-10..10).each do |i|
      x = i * xoffset
      glVertex2f(x, -h); glVertex2f(x, h)
    end

    # Diagonal up
    yoffset = Math.tan(Math::PI / 6) * w
    (-30..10).each do |i|
      y = i * s;
      glVertex2f(-w, y - yoffset); glVertex2f(w, y + yoffset)
    end

    # Diagonal down
    (-10..30).each do |i|
      y = i * s;
      glVertex2f(-w, y + yoffset); glVertex2f(w, y - yoffset)
    end

    glEnd()
  end
end