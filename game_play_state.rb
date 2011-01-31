class GamePlayState
  def initialize(owner)
    @owner = owner

    # Make every thing unselectable at this point.
    @owner.view.render_list.each { | item | item.selectable = false }

    advance_turn
  end

  def advance_turn()
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
    @owner.board.active_player = @owner.board.next_player
  end

  def process_selection(focus)
    # TODO: Confirm their selection.
    focus.model.build @owner.board.active_player
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
