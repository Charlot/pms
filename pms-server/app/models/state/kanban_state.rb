class KanbanState < BaseClass
  INIT = 0
  RELEASED = 1
  LOCKED = 2
  DELETED = 3

  def self.display(state)
    case state
    when INIT
      'Init'
    when RELEASED
      'Released'
    when LOCKED
      'Locked'
    when DELETED
      'Deleted'
    end
  end
end