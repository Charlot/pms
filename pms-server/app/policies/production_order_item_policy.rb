class ProductionOrderItemPolicy<ApplicationPolicy
  def update?
    user.av? || user.system? || user.cutting?
    #user.has_any_role? :av,:cutting
    true
  end

  def optimise?
    update?
    #user.has_any_role? :av,:cutting
  end

  def distribute
    update?
    #user.has_any_role? :av,:cutting
  end

  def export
    true
  end

  def state_export
    true
  end
end