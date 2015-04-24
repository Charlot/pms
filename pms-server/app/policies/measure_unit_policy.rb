class MeasureUnitPolicy<ApplicationPolicy
  def update?
    user.av?
  end

  def destroy?
    update?
  end

  def create?
    update?
  end
end