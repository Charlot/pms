class MeasureUnitPolicy<ApplicationPolicy
  def update?
    user.av?
  end
end