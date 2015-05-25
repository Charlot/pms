class UserPolicy<ApplicationPolicy
  def update?
    user.admin? || user.system?
    true
  end
end