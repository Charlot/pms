class ToolPolicy<ApplicationPolicy
  def update?
    user.av?
  end
end