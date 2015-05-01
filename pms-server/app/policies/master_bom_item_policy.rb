class MasterBomItemPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
  end
  def transport?
    update?
  end
end