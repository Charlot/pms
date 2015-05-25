class MachineCombinationPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
    #false
    true
  end

  def export?
    true
    #false
  end
end