require 'opengl'
include Gl,Glu,Glut

require 'GameController'

#  Request double buffer display mode.
glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
glutInitWindowSize(800, 800) 
glutInitWindowPosition(0, 0)
glutCreateWindow($0)

glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
glDepthFunc(GL_LESS)
glEnable(GL_DEPTH_TEST)
glEnable(GL_BLEND)
glEnable(GL_LINE_SMOOTH)
glEnable(GL_POLYGON_SMOOTH)
glLineWidth(2.0)

gc = GameController.new

glutDisplayFunc(lambda { gc.draw }) 
glutReshapeFunc(lambda { | w, h | gc.reshape w, h })
glutMouseFunc(lambda { | button, state, x, y | gc.process_mouse button, state, x, y })
glutKeyboardFunc(lambda { | key, x, y | gc.process_keyboard key, x, y } )

glutMainLoop()