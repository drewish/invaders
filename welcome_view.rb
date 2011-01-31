require 'base_view'

class WelcomeView < BaseView
  def initialize
    super(nil)
    @background_color = [0, 0, 0, 0]
    @render_list << Text.new("Invaders", 0, 3)
    @render_list << Button.new("Start", 0, 0)
  end
end

