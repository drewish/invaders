require 'observer'

class Intersection
  include Observable
  
  attr_reader(:owner, :type, :rgb)
  attr_accessor(:paths)
  
  def initialize(rgb)
    @rgb = rgb
    @owner = nil
    @type = :unsettled
    @paths = []
  end
  
  def inspect
    if @owned
      "<Intersection (#{@type}) owned by #{@owner}>"
    else
      "<Intersection, unowned>"
    end
  end
  
  def <=> (o)
    # TODO: not super stoked on tying these classes together like this.
    Board.key(*@rgb) <=> Board.key(*o.rgb)
  end

  def settled?
    !@owner.nil?
  end
  
  def unsettled?
    @owner.nil?
  end
  
  def build(owner)
    raise ArgumentError, 'Must specify an owner' if owner.nil?
    
    # TODO: test for distance rule
    # TODO: test for road connection (after game setup)
    if unsettled? and owner.pay_for :settlement
      @owner = owner
      @type = :settlement

      changed
    end
    
    notify_observers self, :built
  end
  
  def upgrade
    if @type == :settlement and @owner.pay_for :city
      @type = :city
      
      changed
    end
    
    notify_observers self, :upgraded
  end
  
  def adjacent_intersections
    @paths.map { | path | path.follow_from(self) }
  end
end