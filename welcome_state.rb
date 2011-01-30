require 'TextView'

class WelcomeState
  def initialize(owner)
    @owner = owner
    @owner.view = TextView.new "welcome to invaders"
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
