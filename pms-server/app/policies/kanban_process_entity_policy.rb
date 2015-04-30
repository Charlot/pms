class KanbanProcessEntityPolicy<ApplicationPolicy
  def update?
    user.av?
  end
end