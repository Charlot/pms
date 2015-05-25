class KanbanState < BaseClass
  INIT = 0
  RELEASED = 1
  LOCKED = 2
  DELETED = 3

  # 2015-2-26 added by Tesla Lee
  # Versioned 状态废弃
  # VERSIONED = 4

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

  def self.pre_states(state)
    case state
    when INIT
      [DELETED]
    when RELEASED
      [INIT,LOCKED]
    when LOCKED
      [RELEASED,DELETED]
    when DELETED
      [LOCKED,INIT]
    else
      []
    end
  end

  def self.switch_to(from,to)
    pre_states(to).include?(from)
  end
end