class ProductionOrderPolicy<ApplicationPolicy
  def update?
    user.has_any_role? :cutting,:av
  end

  def destroy?
    user.has_any_role? :cutting,:av
  end

  def create?
    user.has_any_role? :cutting,:av
  end

  def preview?
    user.has_any_role? :cutting,:av
  end
end