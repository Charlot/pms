class SettingPolicy<ApplicationPolicy
  def update?
    user.admin?
    true
  end
end