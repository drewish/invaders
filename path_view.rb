require 'base_view'
require 'Selectable'

class PathView < BaseView
  include Selectable

  def initialize(model)
    super
    @path = model
    left, right = *@path.spots
    @theta = case
    when left.rgb[0] == right.rgb[0]
      60
    when left.rgb[1] == right.rgb[1]
      120
    else
      0
    end
    @x1, @y1 = *xy_from_rgb(*left.rgb)
    @x2, @y2 = *xy_from_rgb(*right.rgb)
  end
  
  def render
    glPushMatrix()
    
    # Rotate the path so it follows the vector from 1 to 2 then move it so it is
    # centered on the midpoint of the two intersections. Remember that the order
    # of transformations is reversed.
    glTranslate((@x1 + @x2) / 2, (@y1 + @y2) / 2, 0.0)
    glRotate(@theta, 0, 0, 1)
    if @path.owner === nil
      glColor(0.8, 0.8, 0.8)
    else
      glColor(*@path.owner.color)
    end
    glBegin(GL_POLYGON)
    glVertex2f(0.5, 0.2); glVertex2f(0.5, -0.2)
    glVertex2f(-0.5, -0.2); glVertex2f(-0.5, 0.2)
    glEnd()
      
    glPopMatrix()
  end
end

