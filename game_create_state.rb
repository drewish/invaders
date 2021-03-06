require 'game_create_view'
require 'board_view'

class GameCreateState
  def initialize(owner)
    @owner = owner
    @owner.view = GameCreateView.new
  end

  def process_selection(focus)
    # @FIXME: This is hacky. Shouldn't rely on the focus being on a button.
    case focus.text
    when "2"
      choose_players(2)
    when "3"
      choose_players(3)
    when "4"
      choose_players(4)
    when "Exit"
      @owner.state = WelcomeState.new @owner
    end
  end

  def process_keyboard(key, x, y)
    players = {}
    case (key)
    when ?2
      choose_players(2)
    when ?3
      choose_players(3)
    when ?4
      choose_players(4)
    # Escape or Q returns to title screen.
    when ?\e, ?q
      @owner.state = WelcomeState.new @owner
    end
  end

  def choose_players(count)
    players = {:red => [1, 0, 0], :blue => [0, 0, 1]}
    if count > 2
      players[:green] = [0, 1, 0]
    end
    if count > 3
      players[:yellow] = [1, 1, 0]
    end

    board = Board.new(players.collect { | name, color | Player.new(self, name, color) })
    @owner.state = GameSetupState.new @owner, board
  end
end