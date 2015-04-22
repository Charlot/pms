class ProductionOrderItemPolicy<ApplicationPolicy
  def new?
    user.has_any_role? :av,:cutting
  end

  def update?
    user.has_any_role? :av,:cutting
  end

  def edit?
    user.has_any_role? :av,:cutting
  end

  def create?
    user.has_any_role? :av,:cutting
  end

  def update?
    user.has_any_role? :av,:cutting
  end

  def destroy?
    user.has_any_role? :av,:cutting
  end

  def optimise?
    user.has_any_role? :av,:cutting
  end

  def distribute
    user.has_any_role? :av,:cutting
  end

  def export
    true
  end

  def state_export
    true
  end
end