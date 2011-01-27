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
  
  def process_mouse(button, state, x, y)
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

  def process_mouse(button, state, x, y)
  end

  def process_keyboard(key, x, y)
    players = {}
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    when ?1
      players = {:red => [1, 0, 0]}
    when ?2
      players = {:red => [1, 0, 0], :blue => [0, 0, 1]}
    when ?3
      players = {:red => [1, 0, 0], :blue => [0, 0, 1], :green => [0, 1, 0]}
    when ?4
      players = {:red => [1, 0, 0], :blue => [0, 0, 1], :green => [0, 1, 0], :yellow => [1, 1, 0]}
    end

    if players.count > 0
@owner.state = WelcomeState.new @owner
return
#      @owner.state = GameSetupState.new @owner
      @owner.board = Board.new(players)
      @owner.view = BoardView.new(@owner.board)
    end
  end
end

class GameSetupState
  def initialize(owner)
    @owner = owner
  end

  def process_mouse(button, state, x, y)
  end

  def process_keyboard(key, x, y)
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    else
      @owner.state = GamePlayState.new @owner
    end
  end
end

class GamePlayState
  def initialize(owner)
    @owner = owner
    @i = 0
  end

  def process_mouse(button, state, x, y)
  end

  def process_keyboard(key, x, y)
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    else 
      @i += 1
      
      if @i > 5
        @owner.state = GameSummaryState.new @owner
      end

      board = @owner.board
      board.intersections.values.first.build(board.players[:red])
      board.paths.values.first.build(board.players[:red])
      board.intersections.values.last.build(board.players[:blue])
      board.paths.values.last.build(board.players[:blue])
    end
  end
end

class GameSummaryState
  def initialize(owner)
    @owner = owner
    @owner.view = TextView.new "someone one won!"
  end
  
  def process_mouse(button, state, x, y)
  end

  def process_keyboard(key, x, y)
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
    @view.selected x, y
    glutPostRedisplay()
  end

  def process_mouse(button, state, x, y)
    if (state == GLUT_DOWN)
      case button
        when GLUT_LEFT_BUTTON
          @state.process_mouse button, state, x, y
          @view.selected x, y
          glutPostRedisplay()
        when GLUT_RIGHT_BUTTON
      end
    end
  end
end