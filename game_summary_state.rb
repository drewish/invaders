class GameSummaryState
  def initialize(owner)
    @owner = owner
    @owner.view = TextView.new "someone one won!"
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