require 'selectable'

class Text
  attr_reader :text
  attr_accessor :background_color, :text_color
  
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
      glColor(@background_color)
      glVertex(width, 1, 0)
      glVertex(-width, 1, 0)
      glVertex(-width, -1, 0)
      glVertex(width, -1, 0)
      glEnd()
    end
    
    # Text
    glColor(@text_color)
    glRasterPos3f(-width / 2, -0.15, 0);
    @text.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }

    glPopMatrix()  
  end
end

class Button
  include Selectable

  attr_reader :text
  attr_accessor :background_color, :text_color

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

class BaseView
  attr_accessor :model, :render_list, :background_color

  def initialize(model)
    @model = model
    @model.add_observer(self) if @model.kind_of?(Observable)
    @render_list = []
    @background_color = [1, 1, 1, 0]    
  end
  
  def update(noun, verb)
    glutPostRedisplay()
  end

  # Render is called by draw and detect_selection.
  def render
    glClearColor(*@background_color)
    @render_list.each { | o | o.render }
  end

  def draw
    glClearColor(*@background_color)
    @render_list.each { | o | o.render }
  end

  # pickRects() sets up selection mode, name stack,
  # and projection matrix for picking.  Then the objects
  # are drawn.
  def detect_selection(x, y)
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
# TODO: should put this in one common spot.
    glOrtho(-10.0, 10.0, -10.0, 10.0, -0.5, 2.5)

    # Determine what can be selected, render those items using the array index 
    # as their names.
    selectable = @render_list.select do | item | 
      item.kind_of?(Selectable) && item.selectable
    end
    selectable.each_index do | i |
      glLoadName(i)
      selectable[i].render
    end

    glPopMatrix()
    glFlush()

    hits = glRenderMode(GL_RENDER)
    selected_name_stacks = processHits(hits, selectBuf)
    
    # Clear the selected list.
    @render_list.each do | item | 
      item.selected = false if item.kind_of?(Selectable)
    end
    # Look up what was selected out of what was selectable.
    selected = []
    selected_name_stacks.each do | name_stack |
      # FIXME: this assumes the stack has fixed height.
      raise Error, 'too man hits ' unless name_stack.count <= 1
      item = selectable[name_stack[0]]
      item.selected = true
      selected << item
    end

    selected
  end

  # processHits() prints out the contents of the
  # selection array.
  def processHits(hits, buffer)
    result = []
    puts "Hits = #{hits}"
    ptr = buffer.unpack("I*")
    # Hit records are variable length. First element is the record length,
    # then the z-indexes, finally the name stack.
    p = 0
    for i in 0...hits
      name_count = ptr[p]
      z1 = ptr[p + 1].to_f / 0xffffffff
      z2 = ptr[p + 2].to_f / 0xffffffff
      names = ptr[p + 3, name_count]
      p += 3 + name_count;

      #puts " number of names for hit = #{name_count}"
      #puts " z1 is #{z1}"
      #puts " z2 is #{z2}"
      #puts "Names = " + names.inspect
      
      result << names
    end
    result
  end
  
  # Convert between our RGB coordinate system and XY.
  SQRT_3_2 = Math.sqrt(3) / 2
  def xy_from_rgb(r, g, b, s = 1)
    raise ArgumentError, 'r + g + b != 0' unless r + b + g == 0
    # Figure out the slope of 210 and 330 degree lines. On the unit circle that
    # equals: (-sqrt(3)/2, -1/2) and (sqrt(3)/2, -1/2).
    rx = r * SQRT_3_2
    ry = r * -0.5
    gx = g * -SQRT_3_2
    gy = g * -0.5
    bx = 0
    by = b
    [ s * (rx + gx + bx), s * (ry + gy + by)]
  end
end