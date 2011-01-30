module ContainsSelectable
  attr_accessor :render_list, :selectable, :hover
  
  def selectable
    @render_list.select { | item | item.selectable }
  }

  def selected=(value)
    value = [ value ].flatten
    selectable.each { | item | item.selected = value.include?(item) }
  end

  def selected
    @render_list.select { | item | item.selected }
  end
end