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
  
  # TODO: This should be moved out of here.    
  def build(owner)
    raise ArgumentError, 'Must specify an owner' if owner.nil?
    
    if @type == :unsettled
      @owner = owner
      @type = :settlement
      @owner.pay_for self

      changed
      notify_observers self, :built
    end    
  end
  
  def upgrade
    if @type == :settlement
      @type = :city
      @owner.pay_for self
      
      changed
      notify_observers self, :upgraded
    end
  end
  
  def adjacent_intersections
    @paths.map { | path | path.follow_from(self) }
  end
end