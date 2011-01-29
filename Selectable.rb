require "observer"

module Selectable
  include Observable

  attr_reader :selectable, :selected, :hover

  def selectable=(value)
    return if @selectable == value

    changed
    @selectable = value
    notify_observers self, :selectable
  end    

  def selected=(value)
    return if @selected == value

    changed
    @selected = value
    notify_observers self, :selected
  end
  
  def hover=(value)
    return if @hover == value

    changed
    @hover = value
    notify_observers self, :hover
  end
end
