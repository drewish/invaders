require 'base_view'
require 'selectable'

class DiceView < BaseView
  include Selectable
  
  def initialize(model)
    raise ArgumentError, 'Must specify a model' if model.nil?

    super model
    @dice = model
  end

  def render
    @dice.values.each_index do | i |
      glPushMatrix()
      
      glTranslate(-2 + 2 * i, -9, 0)

      glColor(1, 1, 1)
      glBegin(GL_POLYGON)
      glVertex2f(1, 1); glVertex2f(1, -1)
      glVertex2f(-1, -1); glVertex2f(-1, 1)
      glEnd()

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

