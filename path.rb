require 'observer'

class Path
  include Observable

  attr_accessor :owner, :intersections
  
  def initialize(left, right)
    @owner = nil
    @intersections = [left, right]
    @intersections.each { | intersection | intersection.paths << self }
  end

  def inspect
    if @owner 
      "<Path owned by #{@owner}>"
    else
      "<Path unowned>"
    end
  end
  
  def settled?
    !@owner.nil?
  end
  
  def unsettled?
    @owner.nil?
  end

  def build(owner)
    raise ArgumentError, 'Must specify an owner' if owner.nil?
    
    if unsettled? and owner.pay_for :road
      changed
      @owner = owner
    end
    
    notify_observers self, :built
  end
  
  # Given an intersection return the other side of the path.
  def follow_from(i)
    if @intersections.include? i
      @intersections[0] == i ? @intersections[1] : @intersections[0]
    else
      nil
    end
  end
end
