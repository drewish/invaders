class GlView
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

      puts " number of names for hit = #{name_count}"
      puts " z1 is #{z1}"
      puts " z2 is #{z2}"
      puts "Names = " + names.inspect
      
      result << names
    end
    result
  end
end