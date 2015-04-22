class UserPolicy<ApplicationPolicy
  def create?
    user.has_role? :admin
  end

  def update?
    user.id == record.id || (user.has_role? :admin)
  end

  def destroy?
    user.has_role? :admin
  end
end