require 'opengl'
include Gl,Glu,Glut

require 'Board'
require 'BoardView'

board = Board.new [:red, :blue]
view = BoardView.new board

# Register keyboard/mouse callbacks
mouse = Proc.new do |button, state, x, y|
  case button
    when GLUT_LEFT_BUTTON
#          glutIdleFunc(spinDisplay) if (state == GLUT_DOWN)
        when GLUT_RIGHT_BUTTON
#          glutIdleFunc(nil) if (state == GLUT_DOWN)
  end
end
glutMouseFunc(mouse)

keyboard = Proc.new do |key, x, y|
  case (key)
    when ?\e
      exit(0)
  end
end
glutKeyboardFunc(keyboard)

glutMainLoop()
