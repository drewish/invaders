
class GameSetupState
  def initialize(owner)
    @owner = owner

    # Two ways to roll 3-6 and 8-11, omitting 7 since desert is a special case.
    tile_rolls = [2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11, 12].sort_by { rand }
    tile_types = [
      :brick, :brick, :brick,
      :ore, :ore, :ore,
      :grain, :grain, :grain, :grain,
      :lumber, :lumber, :lumber, :lumber, 
      :wool, :wool, :wool, :wool
    ].sort_by { rand }

    tile_settings = [ {:type => :desert, :roll => 7} ]
    (0...18).each do | i |
      tile_settings << {:type => tile_types[i], :roll => tile_rolls[i]} 
    end
    tile_settings = tile_settings.sort_by { rand }

    @owner.board.tiles.each do | key, tile | 
      settings = tile_settings.pop
      tile.type, tile.roll = settings[:type], settings[:roll]
    end

    # TODO: consult rules for picking first player which would affect order of @players.
    players = @owner.board.players.values
    @player = nil
    # Everyone gets two turns: first to last then last to first.
    @turns_remaining = players + players.reverse
    @last_piece = nil

    # Titles aren't selectable in this phase.
    @owner.board.tiles.each_value { | item | item.selectable = false }

    advance_turn
  end

  def advance_turn()
#puts "advancing the turn\n\n"
#puts @turns_remaining
    # Figure out what we should be doing in this part of the turn. 
#puts "last piece: " + @last_piece.to_s
    if @last_piece == nil || @last_piece.kind_of?(Path)
      if @turns_remaining.count == 0
        @owner.state = GamePlayState.new @owner
        return
      end
      @player = @turns_remaining.shift
      type_of_next_piece = :intersection
    else
      type_of_next_piece = :path
    end

    # Determine selectable list (first half of the turn is picking an 
    # intersection then a path).
    # - unsettled intersections, where all adjacent intersections are unsettled.
    # - unsettled paths adjacent to last settlement built.
    
    @owner.board.paths.each_value do | item |
      item.selectable = (:path == type_of_next_piece)
    end
    @owner.board.intersections().each_value do | item |
      item.selectable = (:intersection == type_of_next_piece)
    end
  end

  def process_selection(focus)
    # TODO: Confirm their selection.
    focus.build @player
    @last_piece = focus
    advance_turn
  end

  def process_keyboard(key, x, y)
    # Just let them exit for now.
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    end
  end
end
