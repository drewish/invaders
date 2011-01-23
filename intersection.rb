class Intersection
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
    # TODO: test for distance rule
    # TODO: test for road connection (after game setup)
    if @owner.nil? and owner.pay_for :settlement
      @owner = owner
      @type = :settlement
    end
  end
  
  def upgrade
    if @type == :settlement and @owner.pay_for :city
      @type = :city
    end
  end
end