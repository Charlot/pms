class MasterBomItemPolicy<ApplicationPolicy
  def update?
    user.av?
  end

  def create?
    update?
  end

  def destroy?
    update?
  end

  def transport?
    update?
  end
end