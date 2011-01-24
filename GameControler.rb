require 'opengl'
include Gl,Glu,Glut

require 'Board'
require 'BoardView'

board = Board.new({:red => [1.0, 0.0, 0.0], :blue => [0.0, 0.0, 1.0]})
view = BoardView.new board
board.intersections.values.first.build(board.players[:red])
board.intersections.values.last.build(board.players[:blue])
board.intersections.values.last.upgrade
board.paths.values.first.build(board.players[:red])
board.paths.values.last.build(board.players[:blue])

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
