require 'opengl'
include Gl,Glu,Glut

require 'Board'
require 'BoardView'
require 'TextView'

require 'welcome_state'
require 'game_create_state'
require 'game_setup_state'
require 'game_play_state'
require 'game_summary_state'

class GameController
  attr_reader :state
  attr_accessor :board, :view

  def initialize
    @view = nil
    @board = nil
    @state = WelcomeState.new self
  end

  def state=(value)
    @state = value
    # Make sure the new state has a chance to draw.
    glutPostRedisplay()
  end

  def draw
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
puts @view.inspect
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
  end
end