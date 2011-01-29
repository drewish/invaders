class GamePlayState
  def initialize(owner)
    @owner = owner

    # TODO: consult rules for picking first player which would affect order of @players.
    @players = @owner.board.players.values

    advance_turn
  end

  def advance_turn()
puts "advancing the turn\n\n"
#puts @turns_remaining

    @players.rotate
    @players.first
    
    @owner.board.paths.each_value do | item |
      item.selectable = true
    end
    @owner.board.intersections().each_value do | item |
      item.selectable = true
    end
  end

  def process_selection(focus)
    # TODO: Confirm their selection.
    focus.build @player
    @last_piece = focus
    advance_turn
  end

  def process_keyboard(key, x, y)
    # FIXME: Just let them exit for now.
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    end
  end
end
