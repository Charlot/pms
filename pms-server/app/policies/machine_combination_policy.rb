class MachineCombinationPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
    #false
  end

  def export?
    true
    #false
  end
end