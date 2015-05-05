class UserPolicy<ApplicationPolicy
  def update?
    user.admin? || user.system?
  end
end