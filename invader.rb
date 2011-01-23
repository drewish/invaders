require 'opengl'
require 'rational'
include Gl,Glu,Glut

require 'Board'

  
display = Proc.new do
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

  $board.tiles.each do | key, t |
    draw_tile t
  end

  $board.intersections.each do | key, i |
    draw_intersection i
  end

  $board.paths.each do | key, p |
    draw_path p
  end
  
#  draw_hex_lines(s)
  
  glutSwapBuffers()
end

def xy_from_rgb(r, g, b, s = 1)
  raise ArgumentError, 'r + g + b != 0' unless r + b + g == 0
  # Figure out the slope of 210 and 330 degree lines. On the unit circle that 
  # equals: (-sqrt(3)/2, -1/2) and (sqrt(3)/2, -1/2).
  sq32 = Math.sqrt(3) / 2
  rx = r * sq32 
  ry = r * -0.5
  gx = g * -sq32
  gy = g * -0.5
  bx = 0
  by = b
  [ s * (rx + gx + bx), s * (ry + gy + by)]
end

def draw_tile(tile)
  glPushMatrix()

  x, y = *xy_from_rgb(*tile.rgb)
  glTranslate(x, y, 0.0)
#  glScale(3, 3, 1)
  glColor(0.7, 0.7, 0.7)
  glCallList($startList)
  
  glPopMatrix()
end

def draw_intersection(intersection)
  glPushMatrix()

  x, y = *xy_from_rgb(*intersection.rgb)
  glTranslate(x, y, 0.0)
  glColor(0.7, 0.7, 0.7)
  glCallList($startList + 1)
  
  glPopMatrix()
end

def draw_path(path)
  glPushMatrix()

  # Rotate the path so it follows the vector from 1 to 2 then move it so it is
  # centered on the midpoint of the two intersections.
  # to the angle of the two.
  x1, y1 = *xy_from_rgb(*path.spots[0].rgb)
  x2, y2 = *xy_from_rgb(*path.spots[1].rgb)
  theta = 0
  if (path.spots[0].rgb[0] == path.spots[1].rgb[0]) 
    theta = 60
  elsif (path.spots[0].rgb[1] == path.spots[1].rgb[1]) 
    theta = 120
  end
  glTranslate((x1 + x2) / 2, (y1 + y2) / 2, 0.0)
  glRotate(theta, 0, 0, 1)
  glColor(0.7, 0.7, 0.7)
  glCallList($startList + 2)

  glPopMatrix()
end

def draw_hex_lines(s)
  glBegin(GL_LINES)
  
  w = s * 10
  h = s * 10

  # Vertical lines
  xoffset = Math.cos(Math::PI / 6) * s
  (-10..10).each do |i|
    x = i * xoffset
    glVertex2f(x, -h); glVertex2f(x, h)
  end

  # Diagonal up
  yoffset = Math.tan(Math::PI / 6) * w
  (-30..10).each do |i|
    y = i * s;
    glVertex2f(-w, y - yoffset); glVertex2f(w, y + yoffset)
  end
  
  # Diagonal down
  (-10..30).each do |i|
    y = i * s;
    glVertex2f(-w, y + yoffset); glVertex2f(w, y - yoffset)
  end

  glEnd()
end

reshape = Proc.new do |w, h|
  glViewport(0, 0, w, h)

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glOrtho(-10.0, 10.0, -10.0, 10.0, -1.0, 1.0)
  
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
end

mouse = Proc.new do |button, state, x, y|
=begin
  case button
    when GLUT_LEFT_BUTTON
      glutIdleFunc(spinDisplay) if (state == GLUT_DOWN)
    when GLUT_RIGHT_BUTTON
      glutIdleFunc(nil) if (state == GLUT_DOWN)
  end
=end
end

keyboard = Proc.new do |key, x, y|
  case (key)
    when ?\e
      exit(0)
  end
end
 


$board = Board.new([:red, :blue])


#  Request double buffer display mode.
glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
glutInitWindowSize(800, 800) 
glutInitWindowPosition(0, 0)
glutCreateWindow($0)
glClearColor(1.0, 1.0, 1.0, 0.0)
glClearDepth(1.0);
glShadeModel(GL_FLAT)
# Register display/resize callbacks
glutDisplayFunc(display) 
glutReshapeFunc(reshape) 
# Register keyboard/mouse callbacks
glutKeyboardFunc(keyboard)
glutMouseFunc(mouse)

# Setup an object for "points"
$startList = glGenLists(3)
qobj = gluNewQuadric()

gluQuadricDrawStyle(qobj, GLU_FILL) # flat shaded
gluQuadricNormals(qobj, GLU_FLAT)

# Tile
glNewList($startList, GL_COMPILE)
glPushMatrix()
glRotate(30, 0, 0, 1)
gluDisk(qobj, 0, 1.4, 6, 1)
glPopMatrix()
glEndList()

# Intersection
glNewList($startList + 1, GL_COMPILE)
gluDisk(qobj, 0, 0.25, 6, 1)
glEndList()

# Path
glNewList($startList + 2, GL_COMPILE)
glPushMatrix()
glScale(2, 0.5, 1)
glutSolidCube(0.5)
glPopMatrix()
glEndList()

glutMainLoop()
