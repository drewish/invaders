class TextView
  def initialize(text)
    @text = text
  end

  def draw
    glClearColor(0, 0, 0, 0)

    drawRects(GL_RENDER)

    glColor(1, 1, 1)
    glRasterPos3f(0, 0, 0);
    @text.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }
  end
    

  # The three rectangles are drawn.  In selection mode, 
  # each rectangle is given the same name.  Note that 
  # each rectangle is drawn with a different z value.
  def drawRects(mode)
    if (mode == GL_SELECT)
        glLoadName(1)
    end
    glBegin(GL_QUADS)
    glColor(1.0, 1.0, 0.0)
    glVertex(2, 0, 0)
    glVertex(2, 6, 0)
    glVertex(6, 6, 0)
    glVertex(6, 0, 0)
    glEnd()

    if (mode == GL_SELECT)
        glLoadName(2)
    end
    glBegin(GL_QUADS)
    glColor(0.0, 1.0, 1.0)
    glVertex(3, 2, -1)
    glVertex(3, 8, -1)
    glVertex(8, 8, -1)
    glVertex(8, 2, -1)
    glEnd()

    if (mode == GL_SELECT)
        glLoadName(3)
    end
    glBegin(GL_QUADS)
    glColor(1.0, 0.0, 1.0)
    glVertex(0, 2, -2)
    glVertex(0, 7, -2)
    glVertex(5, 7, -2)
    glVertex(5, 2, -2)
    glEnd()
  end

  # pickRects() sets up selection mode, name stack, 
  # and projection matrix for picking.  Then the objects 
  # are drawn.
  def selected(x, y)
    viewport = glGetDoublev(GL_VIEWPORT)
    
    selectBuf = glSelectBuffer(512)
    glRenderMode(GL_SELECT)
    
    glInitNames()
    glPushName(~0)
    
    glMatrixMode(GL_PROJECTION)
    glPushMatrix()
    glLoadIdentity()
    # create 5x5 pixel picking region near cursor location
    gluPickMatrix( x, viewport[3] - y, 10.0, 10.0, viewport)
    glOrtho(-10.0, 10.0, -10.0, 10.0, -0.5, 2.5)
    
    drawRects(GL_SELECT)
    glPopMatrix()
    glFlush()
    
    hits = glRenderMode(GL_RENDER)
    processHits(hits, selectBuf)
  end

  # processHits() prints out the contents of the 
  # selection array.
  def processHits(hits, buffer)
      printf("hits = %d\n", hits)
      ptr = buffer.unpack("I*")
      p = 0
      for i in 0...hits 	# for each hit
          names = ptr[p]
          printf(" number of names for hit = %d\n", names); p+=1
          printf("  z1 is %g",  ptr[p].to_f/0xffffffff); p+=1
          printf(" z2 is %g\n",  ptr[p].to_f/0xffffffff); p+=1
          printf("   the name is ")
          for j in 0...names  # for each name
              printf("%d ", ptr[p]) ; p+=1
          end
          printf("\n")
      end
  end
end