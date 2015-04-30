class PartPositionPolicy<ApplicationPolicy
  def update?
    user.av?
  end
end