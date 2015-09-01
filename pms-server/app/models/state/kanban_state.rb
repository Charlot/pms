class KanbanState < BaseClass
  INIT = 0
  RELEASED = 1
  LOCKED = 2
  DELETED = 3
  DESTROYED=4

  # 2015-2-26 added by Tesla Lee
  # Versioned 状态废弃
  # VERSIONED = 4

  def self.display(state)
    case state
      when INIT
        'INIT'
      when RELEASED
        'RELEASED'
      when LOCKED
        'LOCKED'
      when DELETED
        'DELETED'
      when DESTROYED
        'DESTROYED'
    end
  end

  def self.get_value_by_display(display)

    self.const_get(display) if self.constants.include?(display.to_sym)

  end

  def self.pre_states(state)
    case state
      when INIT
        [DELETED]
      when RELEASED
        [INIT, LOCKED, DELETED]
      when LOCKED
        [RELEASED, DELETED]
      when DELETED
        [RELEASED, LOCKED, INIT]
      else
        []
    end
  end

  def self.switch_to(from, to)
    pre_states(to).include?(from)
  end
end
