class WarehousePolicy<ApplicationPolicy
  def update?
    user.av?
  end
end