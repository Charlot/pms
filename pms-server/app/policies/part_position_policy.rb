class PartPositionPolicy<ApplicationPolicy
  def update?
    user.av?
  end

  def create?
    update?
  end

  def destroy?
    update?
  end
end