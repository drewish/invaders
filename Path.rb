class Path
  attr_accessor :owner, :spots
  
  def initialize(left, right)
    @owner = nil
    @spots = [left, right]
    @spots.each { |spot| spot.road = self }
  end
  
  def build(owner)
    if @owner.nil? and owner.pay_for :road
      @owner = owner
    end
  end
end
