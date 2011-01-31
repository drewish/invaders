require 'welcome_view'

class WelcomeState
  def initialize(owner)
    @owner = owner
    @owner.view = WelcomeView.new
  end

  def process_selection(focus)
    @owner.state = GameCreateState.new @owner
  end

  def process_keyboard(key, x, y)
    case (key)
    # Space or enter advances.
    when ?\s, ?\n
      @owner.state = GameCreateState.new @owner
    # Escape or Q quits.
    when ?\e, ?q
      exit(0)
    end
  end
end
