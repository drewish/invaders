require 'base_view'
require 'selectable'

class Text
  def initialize(text, x, y)
    @text, @x, @y = text, x, y
    @text_color = [1,1,1]
    @background_color = nil
    @selectable = true
  end

  def render
    glPushMatrix()
    
    width = @text.each_byte.inject(0) do | memo, c|
      memo + glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, c)
    end
    width *= 0.01

    glTranslate(@x, @y, 0.0)

    # Background
    if @background_color
      glBegin(GL_QUADS)
      glColor(*@background_color)
      glVertex(width, 1, 0)
      glVertex(-width, 1, 0)
      glVertex(-width, -1, 0)
      glVertex(width, -1, 0)
      glEnd()
    end
    
    # Text
    glColor(*@text_color)
    glRasterPos3f(-width / 2, -0.15, 0);
    @text.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }

    glPopMatrix()  
  end
end

class Button
  include Selectable

  def initialize(text, x, y)
    @text, @x, @y = text, x, y
    @text_color = [1,1,1]
    @background_color = [0,1,1]
    @selectable = true
  end

  def render
    glPushMatrix()
    
    width = @text.each_byte.inject(0) do | memo, c|
      memo + glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, c)
    end
    width *= 0.1

    glTranslate(@x, @y, 0.0)

    # Background
    glBegin(GL_QUADS)
    glColor(*@background_color)
    glVertex(width, 1, 0)
    glVertex(-width, 1, 0)
    glVertex(-width, -1, 0)
    glVertex(width, -1, 0)
    glEnd()

    # Text
    glColor(*@text_color)
    glRasterPos3f(-width / 2, -0.15, 0);
    @text.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }

    glPopMatrix()  
  end
end

class TextView < BaseView
  def initialize(text)
    super
    @text = text
    @render_list << Button.new(text, 0, 0)
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
end