class SettingPolicy<ApplicationPolicy
  def update?
    user.admin?
  end
end