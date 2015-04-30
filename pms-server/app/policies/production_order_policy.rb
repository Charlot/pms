class ProductionOrderPolicy<ApplicationPolicy
  def update?
    user.av? || user.cutting?
    #user.has_any_role? :cutting,:av
  end

  def preview?
    #user.has_any_role? :cutting,:av
    update?
  end
end