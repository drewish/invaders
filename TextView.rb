class TextView
  def initialize(text)
    @text = text
  end

  def draw
    glClearColor(0, 0, 0, 0)
    glColor(1, 1, 1)
    glRasterPos3f(0, 0, 0);
    @text.each_byte { |c| glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, c) }
  end
end