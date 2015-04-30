class KanbanProcessEntityPolicy
  def update?
    user.av?
  end
end