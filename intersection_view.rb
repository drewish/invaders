require 'base_view'
require 'selectable'

class IntersectionView < BaseView
  include Selectable

  def initialize(model)
    super
    @intersection = model
    @x, @y = *xy_from_rgb(*@intersection.rgb)
  end
  
  def render
    glPushMatrix()

    qobj = gluNewQuadric()
    gluQuadricDrawStyle(qobj, GLU_FILL)

    glTranslate(@x, @y, 0.0)
    
    case @intersection.type
    when :unsettled
      if selectable
        glColor(0.6, 0.6, 0.6)
      else
        glColor(0.8, 0.8, 0.8)
      end
      gluDisk(qobj, 0, 0.25, 6, 1)

    when :settlement
      glColor(*@intersection.owner.color)
      gluDisk(qobj, 0, 0.25, 3, 1)

    when :city
      glColor(*@intersection.owner.color)
      gluDisk(qobj, 0, 0.25, 4, 1)
    end

    glPopMatrix()
  end
end

