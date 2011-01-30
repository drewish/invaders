require 'base_view'
require 'Selectable'

class TileView < BaseView
  include Selectable

  def initialize(model)
    super
    @tile = model
    # Tiles don't move so go ahead and just compute this once.
    @x, @y = *xy_from_rgb(*@tile.rgb)
  end
  
  def render
    glPushMatrix()
    
    glTranslate(@x, @y, 0.0)
    glColor(*@tile.color)
    
    # Tile
    qobj = gluNewQuadric()
    gluQuadricDrawStyle(qobj, GLU_FILL)
    glPushMatrix()
    glRotate(30, 0, 0, 1)
    gluDisk(qobj, 0, 1.4, 6, 1)
    glPopMatrix()

    # Text
    glColor(1, 1, 1)
    s = @tile.roll.to_s
    # TODO i'm sure there's an idiom using inject that would be better here.
    width = 0
    s.each_byte { |c| width += glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, c) }
    glRasterPos3f(-0.01 * width, -0.15, 0);
    s.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }

    glPopMatrix()
  end
end