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

    @render_list = @board.tiles.collect { | k, o | TileView.new(o) }
    @render_list += @board.intersections.collect { | k, o | IntersectionView.new(o) }
    @render_list += @board.paths.collect { | k, o | PathView.new(o) }
  end
end