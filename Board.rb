require "observer"

require "Player"
require "Tile"
require "Intersection"
require "Path"


class Board
  include Observable

  def self.key(r, g, b)
    return "#{r}#{g}#{b}"
  end

  attr_accessor :players, :intersections, :paths, :tiles

  def initialize(players)
    @tiles = {}
    @intersections = {}
    @paths = {}
    @players = {}
    @resources = {:brick => 19, :grain => 19, :lumber => 19, :ore => 19, :wool => 19}

    players.each do | name, color|
      @players[name] = Player.new(self, name, color)
    end

    # I'm use a hex grid coordinate system described here:
    #  http://www-cs-students.stanford.edu/~amitp/Articles/Hexagon2.html
    #  http://stackoverflow.com/questions/2459402/hexagonal-grid-coordinates-to-pixel-coordinates
    #

    # Start at the origin then work outward two steps to get all the tiles'
    # coordinates.
    def adjacent_tile_coords(coords)
      tile_offsets = {
        :nw => [-2, 1, 1], :w  => [-1, 2, -1],
        :sw => [1, 1, -2], :se => [2, -1, -1],
        :e  => [1, -2, 1], :ne => [-1, -1, 2]
      }
      result = coords.clone
      coords.each_value do | coord |
        tile_offsets.each_value do | offsets |
          new_coord = [coord[0] + offsets[0], coord[1] + offsets[1], coord[2] + offsets[2]]
          result[Board.key(*new_coord)] = new_coord
        end
      end
      result
    end

    intersection_offsets = {
      :n => [0, -1, 1], :nw  => [-1, 0, 1],
      :sw => [-1, 1, 0], :s => [0, 1, -1],
      :se => [1, 0, -1], :ne => [1, -1, 0]
    }
    tile_coords = adjacent_tile_coords(adjacent_tile_coords({"000" => [0, 0, 0]}))
    tile_coords.each_pair do | key, coords |
      tile = Tile.new(self, coords)
      @tiles[Board.key(*coords)] = tile

      intersection_offsets.each_pair do | intersection_direction, offsets |
        # TODO figure out the right way of doing this.
        rgb = [tile.rgb[0] + offsets[0], tile.rgb[1] + offsets[1], tile.rgb[2] + offsets[2]]
        key = Board.key(*rgb)
        if !@intersections.has_key? key
           @intersections[key] = Intersection.new(rgb)
        end
        tile.intersections[intersection_direction] = @intersections[key]
      end
    end

    # Build paths by conecting intersections.
    path_pairs = {
      :nw => [:n, :nw], :w => [:nw, :sw],
      :sw => [:sw, :s], :se => [:s, :se],
      :e => [:se, :ne], :ne => [:ne, :n],
    }
    @tiles.each_value do | tile |
      path_pairs.each_pair do | path_direction, pair |
        # Sort the intersections so the hashes are consistent.
        left, right = *[tile.intersections[pair[0]], tile.intersections[pair[1]]].sort
        key = Board.key(*left.rgb) + ":" + Board.key(*right.rgb)
        if !@paths.has_key? key
          @paths[key] = Path.new(left, right)
        end
        tile.paths[path_direction] = @paths[key]
      end
    end
    
    # Observe children for changes
    @tiles.each_value { | o | o.add_observer(self) }
    @paths.each_value { | o | o.add_observer(self) }
    @intersections.each_value { | o | o.add_observer(self) }          
  end
  
  # Chain updates.
  def update(noun, verb)
    changed
    notify_observers self, :changed
  end
end
