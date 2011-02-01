class GamePlayState
  COSTS = {
    :road => {:brick => 1, :lumber => 1},
    :settlement => {:brick => 1, :lumber => 1, :grain => 1, :wool => 1},
    :city => {:grain => 2, :ore => 3},
    :development_card => {:wool => 1, :grain => 1, :ore => 1},
  }

  def initialize(owner, board)
    @owner, @board = owner, board

    @board.active_player = @board.players.first
    begin_turn
  end

  def begin_turn
puts "begin_turn"
    # TODO: maybe let them play dev cards/do resources first?
    @board.dice.roll
    @board.produce_resources

    # Make the dice clickable.
    @owner.view.render_list.each { | item | if item.is_a? DiceView then item.selectable = true end }
        
=begin
    # Figure out what we should be doing in this part of the turn. 
    if @last_piece == nil || @last_piece.kind_of?(Path)
      if @turns_remaining.count == 0
        @owner.state = GamePlayState.new @owner
        return
      end
      @owner.board.active_player = @turns_remaining.shift
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
=end
  end

  def finish_turn
puts "finish_turn"
    
    if @board.players.any? { | player | player.score > 10 }
      @owner.state = GameSummaryState.new @owner, @board
    else
      @board.active_player = @board.next_player
      begin_turn
    end
  end

  def process_selection(focus)
    # TODO: Confirm their selection.
#    focus.model.build @board.active_player
#    @last_piece = focus.model
puts focus

    finish_turn
  end

  def process_keyboard(key, x, y)
    case (key)
    # Escape or Q returns to title screen.
    when ?\e, ?q
      @owner.state = WelcomeState.new @owner
    end
  end
end
