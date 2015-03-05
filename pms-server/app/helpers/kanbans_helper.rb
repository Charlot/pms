module KanbansHelper
  def kanban_type_options
    KanbanType.to_select.map{|t| [t.display, t.value]}
  end

  def kanban_states_class state
    case state
    when KanbanState::INIT
      'label-default'
    when KanbanState::RELEASED
      'label-success'
    when KanbanState::LOCKED
      'label-warning'
    when KanbanState::DELETED
      'label-danger'
    else
      'else'
    end
  end
end
