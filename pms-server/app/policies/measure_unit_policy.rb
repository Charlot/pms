class MeasureUnitPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
  end
end