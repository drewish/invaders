require 'board_view'

class GameSetupState
  def initialize(owner, board)
    @owner, @board = owner, board
    @owner.view = BoardView.new(@board)

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

    @board.tiles.each do | key, tile | 
      settings = tile_settings.pop
      tile.type, tile.roll = settings[:type], settings[:roll]
    end

    # TODO: consult rules for picking first player which would affect order of @players.
    players = @board.players
    # Everyone gets two turns: first to last then last to first.
    @turns_remaining = players + players.reverse
    @last_piece = nil

    # Make every thing unselectable at this point.
    @owner.view.render_list.each { | item | item.selectable = false }

    advance_turn
  end

  def advance_turn()
    # Figure out what we should be doing in this part of the turn. 
    if @last_piece == nil || @last_piece.kind_of?(Path)
      if @turns_remaining.count == 0
        @owner.state = GamePlayState.new @owner, @board
        return
      end
      @board.active_player = @turns_remaining.shift
      type_of_next_piece = :intersection
    else
      type_of_next_piece = :path
    end

    # @TODO Determine selectable list (first half of the turn is picking an 
    # intersection then a path).
    @owner.view.render_list.each do | item |
      item.selectable = case item
      when IntersectionView
        # Unsettled intersections, where all adjacent intersections are unsettled.
        type_of_next_piece == :intersection && !item.model.settled? && (item.model.adjacent_intersections.select { |i| i.settled? }.count == 0)
      when PathView
        # Unsettled paths adjacent to last settlement built.
        !item.model.settled? && item.model.intersections.include?(@last_piece)
      end
    end
  end

  def process_selection(focus)
    # TODO: Confirm their selection.
    focus.model.build @board.active_player
    @last_piece = focus.model
    advance_turn
  end

  def process_keyboard(key, x, y)
    case (key)
    # Escape or Q returns to title screen.
    when ?\e, ?q
      @owner.state = WelcomeState.new @owner
    end
  end
end
