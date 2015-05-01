class MachineTimeRulePolicy<ApplicationPolicy
  def update?
    user.av? #|| user.system?
    #false
  end
end