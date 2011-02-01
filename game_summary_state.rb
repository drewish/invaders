class GameSummaryView < BaseView
  def initialize
    super(nil)
    @background_color = [0, 0, 0, 0]
    @render_list << Text.new("Someone Won One!", 0, 3)
    @render_list << Button.new("Continue", 0, 0)
  end
end

class GameSummaryState
  def initialize(owner, board)
    @owner, @board = owner, board
    @owner.view = GameSummaryView.new
  end

  def process_selection(focus)
  end

  def process_keyboard(key, x, y)
    case (key)
    # Escape or Q returns to title screen.
    when ?\e, ?q
      @owner.state = WelcomeState.new @owner
    end
  end
end