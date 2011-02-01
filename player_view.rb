require 'base_view'
require 'selectable'

class PlayerView < BaseView
  include Selectable
  
  attr_reader :index

  def initialize(model, i)
    raise ArgumentError, 'Must specify a model' if model.nil?

    super model
    @player, @index = model, i
  end

  def render
    glPushMatrix()

    glTranslate(-5 + 2 * @index, 9, 0)
    glColor(*@player.color)
    if @player.active?
      glScale(1, 1.4, 1)
    end
    glBegin(GL_POLYGON)
    glVertex2f(1, 1); glVertex2f(1, -1)
    glVertex2f(-1, -1); glVertex2f(-1, 1)
    glEnd()


    # Text
    glColor(1, 1, 1)

    s = ''
    @player.resources.each{ | type, value | s << type.to_s[0,1] + ":" + value.to_s}
    # TODO i'm sure there's an idiom using inject that would be better here.
    width = 0
    s.each_byte { |c| width += glutBitmapWidth(GLUT_BITMAP_HELVETICA_12, c) }
    glRasterPos3f(-0.01 * width, -0.5, 0);
    s.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, c) }

    s = @player.score.to_s
    glRasterPos3f(0, 0.5, 0);
    s.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }

      
    glPopMatrix()
  end
end

