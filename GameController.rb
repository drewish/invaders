require 'opengl'
include Gl,Glu,Glut

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
    @owner.view = TextView.new "create a new game"
  end

  def process_mouse(button, state, x, y)
  end

  def process_keyboard(key, x, y)
    case (key)
    when ?\e
      @owner.state = WelcomeState.new @owner
    else
      @owner.board = Board.new({:red => [1.0, 0.0, 0.0], :blue => [0.0, 0.0, 1.0]})
      @owner.state = GameSetupState.new @owner
    end
  end
end

class GameSetupState
  def initialize(owner)
    @owner = owner
    @owner.view = BoardView.new(@owner.board)
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
    gluOrtho2D(-10.0, 10.0, -10.0, 10.0)
    
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
  end

  def process_keyboard(key, x, y)
    @state.process_keyboard key, x, y
    glutPostRedisplay()
  end

  def process_mouse(button, state, x, y)
    case button
      when GLUT_LEFT_BUTTON
  #      glutIdleFunc(spinDisplay) if (state == GLUT_DOWN)
      when GLUT_RIGHT_BUTTON
  #      glutIdleFunc(nil) if (state == GLUT_DOWN)
    end

    @state.process_mouse button, state, x, y
    glutPostRedisplay()
  end
end