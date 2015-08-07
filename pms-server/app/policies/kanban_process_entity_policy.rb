class KanbanProcessEntityPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
    true
  end
end