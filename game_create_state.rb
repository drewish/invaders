class GameCreateState
  def initialize(owner)
    @owner = owner
    @owner.view = TextView.new "How many players?"
  end

  def process_selection(focus)
  end

  def process_keyboard(key, x, y)
    players = {}
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    when ?2
      players = {:red => [1, 0, 0], :blue => [0, 0, 1]}
    when ?3
      players = {:red => [1, 0, 0], :blue => [0, 0, 1], :green => [0, 1, 0]}
    when ?4
      players = {:red => [1, 0, 0], :blue => [0, 0, 1], :green => [0, 1, 0], :yellow => [1, 1, 0]}
    end

    if players.count > 0
      @owner.board = Board.new(players)
      @owner.view = BoardView.new(@owner.board)
      @owner.state = GameSetupState.new @owner
    end
  end
end