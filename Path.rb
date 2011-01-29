require "observer"

require "Selectable"

class Path
  include Observable
  include Selectable

  attr_accessor :owner, :spots
  
  def initialize(left, right)
    @owner = nil
    @spots = [left, right]
    @spots.each { |spot| spot.road = self }
  end
  
  def build(owner)
    raise ArgumentError, 'Must specify an owner' unless owner
    
    if @owner.nil? and owner.pay_for :road
      changed
      @owner = owner
    end
    
    notify_observers self, :built
  end
end
