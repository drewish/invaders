require "observer"

module Selectable
  include Observable

  attr_reader :selectable, :selected, :hover

  def selectable=(value)
    changed = @selectable != value
    @selectable = value
    notify_observers :selectable
  end    

  def selected=(value)
    changed = @selected != value
    @selected = value
    notify_observers :selected
  end
  
  def hover=(value)
    changed = @hover != value
    @hover = value
    notify_observers :hover
  end
end
