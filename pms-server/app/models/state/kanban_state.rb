class KanbanState < BaseClass
  INIT = 0
  RELEASED = 1
  LOCKED = 2
  DELETED = 3
  VERSIONED = 4

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
    when VERSIONED
      'Versioned'
    end
  end

  def self.non_versioned_states
    [INIT,RELEASED,LOCKED,DELETED]
  end
end