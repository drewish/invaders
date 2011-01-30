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
    when ?\e
      exit(0)
    else
      @owner.state = GameCreateState.new @owner
    end
  end
end
