require 'observer'

class Tile
  include Observable

  attr_accessor :intersections, :paths
  attr_reader :rgb, :type, :roll

  def initialize(board, rgb)
    @board = board
    @rgb = rgb
    @intersections = {:n => nil, :nw => nil, :sw => nil, :s => nil, :se => nil, :ne => nil }
    @paths = {:nw => nil, :w => nil, :sw => nil, :se => nil, :e => nil, :ne => nil }
    @type = nil
    @roll = 0
  end
  
  def inspect
    "<Tile #{@rgb} #{@type} #{@roll}>"
  end
  
  def type=(value)
    return if @type == value
    
    changed
    @type = value
    notify_observers self, :changed
  end
  
  def roll=(value)
    return if @roll == value
    
    changed
    @roll = value
    notify_observers self, :changed
  end

  def color
    case @type
    when :brick
      [0.7686, 0.3804, 0.2902]
    when :desert
      [0.9686, 0.8745, 0.6745]
    when :ore
      [0.3098, 0.3098, 0.2824]
    when :grain
      [0.949, 0.7569, 0.2941]
    when :lumber
      [0.3608, 0.4784, 0.1843]
    when :wool
      [0.7255, 0.8314, 0.3255]
    else
      [0, 0, 0]
    end
  end
  
  # TODO Might need to move this method to Board to be able to honor the rule:
  # If there is not enough of a given resource to fulfill everyone's 
  # production, then no one receives any of that resource.
  def produce_resources
    if roll == 7
      # TODO place robber
    else
      @intersections.each do | dir, intersection | 
        cards = case intersection.type
          when :settlement then 1
          when :city then 2
          else 0
        end
puts "paying out: #{cards} on #{intersection}"
        if cards > 0
          intersection.owner.resources[@type] += cards
        end
      end
    end
  end
end