require 'base_view'
require 'selectable'

class DiceView < BaseView
  include Selectable
  
  def initialize(model)
    raise ArgumentError, 'Must specify a model' if model.nil?

    super model
    @dice = model
    @qobj = gluNewQuadric()
    gluQuadricDrawStyle(@qobj, GLU_FILL)

  end

  def drawPip(x, y)
    glPushMatrix()
    glTranslate(x, y, 0.0)
    gluDisk(@qobj, 0, 0.1, 10, 1)
    glPopMatrix()
  end

  def drawPips(number, l)
    d = l / 2

    if [1, 3, 5].include?(number)
      drawPip(0, 0)
    end
    if [2, 3, 4, 6].include?(number)
      drawPip(-d, -d)
      drawPip(d, d)
    end
    if [4, 5, 6].include?(number)
      drawPip(-d, d)
      drawPip(d, -d)
    end
    if 6 == number
      drawPip(-d, 0)
      drawPip(d, 0)  
    end
  end
  
  def render
    @dice.values.each_index do | i |
      glPushMatrix()
      
      glTranslate(-2 + 2 * i, -9, 0)

      s = 1
      glColor(1, 1, 1)
      glutSolidCube(s)
      
      glColor(0,0,0)
      drawPips @dice.values[i], s * 0.6
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
      glPopMatrix()
    end    
  end
end

