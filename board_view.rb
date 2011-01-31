require 'opengl'
include Gl,Glu,Glut

require 'board'
require 'base_view'
require 'dice_view'
require 'intersection_view'
require 'path_view'
require 'tile_view'
require 'player_view'

class BoardView < BaseView
  def initialize(board)
    super
    @background_color = [1, 1, 1, 0]

    @board = board
    @board.add_observer(self)

    @render_list = @board.tiles.collect { | k, o | TileView.new(o) }
    @render_list += @board.intersections.collect { | k, o | IntersectionView.new(o) }
    @render_list += @board.paths.collect { | k, o | PathView.new(o) }
    # In ruby 1.9 it sounds like ary.each_with_index.collect { |o, i| ... }
    # would be the best way to do this, but for now we'll manage.
    @board.players.each_index do | i | 
      @render_list << PlayerView.new(@board.players[i], i)
    end
    @render_list << DiceView.new(@board.dice)
  end
end