class GameSummaryState
  def initialize(owner)
    @owner = owner
    @owner.view = TextView.new "someone one won!"
  end

  def process_selection(focus)
  end

  def process_keyboard(key, x, y)
    # FIXME: Just let them exit for now.
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    end
  end
end