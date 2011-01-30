def render_hex_lines(s)
  glBegin(GL_LINES)

  w = s * 10
  h = s * 10

  # Vertical lines
  xoffset = Math.cos(Math::PI / 6) * s
  (-10..10).each do |i|
    x = i * xoffset
    glVertex2f(x, -h); glVertex2f(x, h)
  end

  # Diagonal up
  yoffset = Math.tan(Math::PI / 6) * w
  (-30..10).each do |i|
    y = i * s;
    glVertex2f(-w, y - yoffset); glVertex2f(w, y + yoffset)
  end

  # Diagonal down
  (-10..30).each do |i|
    y = i * s;
    glVertex2f(-w, y + yoffset); glVertex2f(w, y - yoffset)
  end

  glEnd()
end
  
def render_hex_tile
  x60 = Math.sqrt(3)/2
  hex = [[0, 1],
	[-x60, 0.5],
	[-x60, -0.5],
	[0, -1],
	[x60, -0.5],
	[x60, 0.5]]

  # stick the z coordinate on the end.
  vertices = []
  (0..1).each do |z|
	hex.each do |vert| 
      vert[2] = z
      vertices << vert
 	end
  end

  glEnableClientState(GL_VERTEX_ARRAY)	
  glVertexPointer(3, GL_FLOAT, 0, vertices.flatten.pack("f*"))

=begin
  indices = (0..5).to_a
  glDrawElements(GL_POLYGON, 6, GL_UNSIGNED_INT, indices.pack("I*"))
  
  indices = (6..11).to_a
  glDrawElements(GL_POLYGON, 6, GL_UNSIGNED_INT, indices.pack("I*"))
=end

  (0..1).each do |i|
    indices = [i, i + 6, i + 7, (i + 1) % 6]
puts indices.inspect
    glDrawElements(GL_QUAD_STRIP, 4, GL_UNSIGNED_INT, indices.pack("I*"))
  end
end