class MasterBomItemPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
    true
  end
  def transport?
    update?
  end
end