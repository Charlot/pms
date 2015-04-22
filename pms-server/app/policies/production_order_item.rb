class ProductionOrderItemPolicy<ApplicationPolicy
  def show?
    true
  end

  def new?
    user.has_role? [:av,:cutting]
  end

  def create?
    user.has_role? [:av,:cutting]
  end

  def update?
    user.has_role? [:av,:cutting]
  end

  def destroy?
    user.has_role? [:av,:cutting]
  end

  def optimise?
    user.has_role? [:av,:cutting]
  end

  def distribute
    user.has_role? [:av,:cutting]
  end

  def export
    true
  end

  def state_export
    true
  end

  def search
    true
  end
end