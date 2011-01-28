require 'opengl'
include Gl,Glu,Glut

require 'Board'
require 'BoardView'
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

class GameSetupState
  def initialize(owner)
    @owner = owner

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

class GameSummaryState
  def initialize(owner)
    @owner = owner
    @owner.view = TextView.new "someone one won!"
  end

  def process_selection(focus)
  end

  def process_keyboard(key, x, y)
    # FIXME: Just let them exit for now.
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    end
  end
end

class GameController
  attr_accessor :state, :board, :view

  def initialize
    @view = nil
    @board = nil
    @state = WelcomeState.new self
  end

  def draw
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    @view.draw
    glutSwapBuffers()
  end

  def reshape(w, h)
    glViewport(0, 0, w, h)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-10.0, 10.0, -10.0, 10.0, -1, 2.5)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
  end

  def process_keyboard(key, x, y)
    @state.process_keyboard key, x, y
#    @view.detect_selection x, y
    glutPostRedisplay()
  end

  def process_mouse(button, state, x, y)
    if (state == GLUT_DOWN)
      case button
        when GLUT_LEFT_BUTTON
          selection = @view.detect_selection(x, y)
          if selection && selection.count
            selection.each { | item | @state.process_selection item }
          end
        when GLUT_RIGHT_BUTTON
      end
    end
    glutPostRedisplay()
  end
end