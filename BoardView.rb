require 'opengl'
include Gl,Glu,Glut

require 'Board'

class BoardView

  def initialize(board)
    #  Request double buffer display mode.
    glutInit
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
    glutInitWindowSize(800, 800) 
    glutInitWindowPosition(0, 0)
    glutCreateWindow($0)

    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glEnable(GL_BLEND)
    glEnable(GL_LINE_SMOOTH)
    glEnable(GL_POLYGON_SMOOTH)
    glLineWidth(2.0)
    glClearColor(1.0, 1.0, 1.0, 0.0)

    @board = board

    # Register display/resize callbacks
    display = Proc.new do
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

      @board.tiles.each { | key, t | draw_tile t }
      @board.intersections.each { | key, i | draw_intersection i }
      @board.paths.each { | key, p | draw_path p }

      # draw_hex_lines(s)
      
      glutSwapBuffers()
    end
    glutDisplayFunc(display) 
    
    reshape = Proc.new do |w, h|
      glViewport(0, 0, w, h)

      glMatrixMode(GL_PROJECTION)
      glLoadIdentity()
      gluOrtho2D(-10.0, 10.0, -10.0, 10.0)
      
      glMatrixMode(GL_MODELVIEW)
      glLoadIdentity()
    end
    glutReshapeFunc(reshape) 

    @startList = build_models
  end
  
  def build_models
    # Setup an object for "points"
    startList = glGenLists(6)
    qobj = gluNewQuadric()

    gluQuadricNormals(qobj, GLU_FLAT)

    # Tile
    gluQuadricDrawStyle(qobj, GLU_FILL)
    glNewList(startList, GL_COMPILE)
    glPushMatrix()
    glRotate(30, 0, 0, 1)
    gluDisk(qobj, 0, 1.4, 6, 1)
    glPopMatrix()
    glEndList()

    # Empty intersection
    gluQuadricDrawStyle(qobj, GLU_SILHOUETTE);
    glNewList(startList + 1, GL_COMPILE)
    gluDisk(qobj, 0, 0.25, 6, 1)
    glEndList()

    # Settled intersection
    gluQuadricDrawStyle(qobj, GLU_FILL)
    glNewList(startList + 2, GL_COMPILE)
    gluDisk(qobj, 0, 0.25, 3, 1)
    glEndList()

    # City intersection
    gluQuadricDrawStyle(qobj, GLU_FILL)
    glNewList(startList + 3, GL_COMPILE)
    gluDisk(qobj, 0, 0.25, 4, 1)
    glEndList()

    # Empty path
    glNewList(startList + 4, GL_COMPILE)
    glBegin(GL_LINE_LOOP)
    glVertex2f(0.5, 0.2); glVertex2f(0.5, -0.2)
    glVertex2f(-0.5, -0.2); glVertex2f(-0.5, 0.2)
    glEnd()    
    glEndList()

    # Road path
    glNewList(startList + 5, GL_COMPILE)
    glBegin(GL_POLYGON)
    glVertex2f(0.5, 0.2); glVertex2f(0.5, -0.2)
    glVertex2f(-0.5, -0.2); glVertex2f(-0.5, 0.2)
    glEnd()    
    glEndList()

    startList
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
    x, y = *xy_from_rgb(*tile.rgb)

    glPushMatrix()
    glTranslate(x, y, 0.0)
    glColor(*tile.color)
    glCallList(@startList)
    
    #  glPushMatrix()
    glColor(1, 1, 1)
    s = tile.roll.to_s
    # TODO i'm sure there's an idiom using inject that would be better here.
    width = 0
    s.each_byte { |c| width += glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, c) }
    glRasterPos3f(-0.01 * width, -0.15, 0);
    s.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }
      
    #  glPopMatrix()    

    glPopMatrix()
  end

  def draw_intersection(intersection)
    x, y = *xy_from_rgb(*intersection.rgb)

    glPushMatrix()

    glTranslate(x, y, 0.0)
    case intersection.type
    when :unsettled
      glColor(0, 0, 0)#      glColor(0.8, 0.8, 0.8)
      glCallList(@startList + 1)
    when :settlement
      glColor(*intersection.owner.color)
      glCallList(@startList + 2)
    when :city
      glColor(*intersection.owner.color)
      glCallList(@startList + 3)
    end
    
    glPopMatrix()
  end

  def draw_path(path)
    # Rotate the path so it follows the vector from 1 to 2 then move it so it is
    # centered on the midpoint of the two intersections.
    # to the angle of the two.
    left, right = *path.spots
    theta = case 
    when left.rgb[0] == right.rgb[0]
      60
    when left.rgb[1] == right.rgb[1]
      120
    else
      0
    end
    x1, y1 = *xy_from_rgb(*left.rgb)
    x2, y2 = *xy_from_rgb(*right.rgb)

    glPushMatrix()

    glTranslate((x1 + x2) / 2, (y1 + y2) / 2, 0.0)
    glRotate(theta, 0, 0, 1)
    if path.owner === nil
      glColor(0, 0, 0)#      glColor(0.8, 0.8, 0.8)
      glCallList(@startList + 4)
    else
      glColor(*path.owner.color)
      glCallList(@startList + 5)
    end

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
end