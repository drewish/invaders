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

    # Rotate the path so it follows the vector from 1 to 2 then move it so it is
    # centered on the midpoint of the two intersections. Remember that the order
    # of transformations is reversed.
    glTranslate(-5 + 2 * @index, 9, 0)
    glColor(*@player.color)
    if @player.active?
      glScale(1, 1.4, 1)
    end
    glBegin(GL_POLYGON)
    glVertex2f(1, 1); glVertex2f(1, -1)
    glVertex2f(-1, -1); glVertex2f(-1, 1)
    glEnd()
      
    glPopMatrix()
  end
end

