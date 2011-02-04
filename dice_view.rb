require 'base_view'
require 'selectable'

class DiceView < BaseView
  include Selectable
  
  def initialize(model)
    raise ArgumentError, 'Must specify a model' if model.nil?

    super model
    @dice = model
  end

  def drawDot(x, y)
    qobj = gluNewQuadric()
    gluQuadricDrawStyle(qobj, GLU_FILL)
    glPushMatrix()
    glRotate(30, 0, 0, 1)
    gluDisk(qobj, 0, 0.1, 10, 1)
    glPopMatrix()
  end

  def draw1
    glPushMatrix()
    glRotate(30, 0, 0, 1)
    drawDot 0, 0
    glPopMatrix()
  end
  
  def draw3
    gl
  end


  def render
    @dice.values.each_index do | i |
      glPushMatrix()
      
      glTranslate(-2 + 2 * i, -9, 0)

#compute the seven points on the dice in the shape of an H
      lt = [];

      glColor(1, 1, 1)
=begin
      glBegin(GL_POLYGON)
      glVertex2f(1, 1); glVertex2f(1, -1)
      glVertex2f(-1, -1); glVertex2f(-1, 1)
      glEnd()
=end
      glutSolidCube(1)

      glColor(0,0,0)
      drawDot(0,0)
=begin
      d1()
      rY
      d3
      rY
      d6
      rY
      d4
      rX
      d2
      r?
      r?
      d5
=end
      
      # Text
      glColor(0, 0, 0)
      s = @dice.values[i].to_s
      # TODO i'm sure there's an idiom using inject that would be better here.
      width = 0
      s.each_byte { |c| width += glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, c) }
      glRasterPos3f(-0.01 * width, -0.15, 0);
      s.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }
      
      glPopMatrix()
    end    
  end
end

