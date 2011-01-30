require 'base_view'

class GameCreateView < BaseView
  def initialize
    super(nil)
    @render_list << Text.new("How many players", 0, 3)
    @render_list << Button.new("2", -4, 0)
    @render_list << Button.new("3", 0, 0)
    @render_list << Button.new("4", 4, 0)
    @render_list << Button.new("Exit", 1, -3)
  end
end
