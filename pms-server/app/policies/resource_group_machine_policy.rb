class ResourceGroupMachinePolicy<ApplicationPolicy
  def update?
    user.av? || user.admin?
  end
end