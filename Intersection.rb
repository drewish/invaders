require "observer"

require "Selectable"

class Intersection
  include Observable
  include Selectable
  
  attr_reader(:owner, :type, :rgb)
  attr_accessor(:road)
  
  def initialize(rgb)
    @rgb = rgb
    @owner = nil
    @type = :unsettled
  end
  
  def <=> (o)
    # TODO: not super stoked on tying these classes together like this.
    Board.key(*@rgb) <=> Board.key(*o.rgb)
  end

  def build(owner)
    raise ArgumentError, 'Must specify an owner' unless owner
    
    # TODO: test for distance rule
    # TODO: test for road connection (after game setup)
    if @owner.nil? and owner.pay_for :settlement
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
end