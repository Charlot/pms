module KanbansHelper
  def kanban_type_options
    KanbanType.to_select.map{|t| [t.display, t.value]}
  end
end
