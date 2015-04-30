class MasterBomItemPolicy<ApplicationPolicy
  def update?
    user.av?
  end
  def transport?
    update?
  end
end