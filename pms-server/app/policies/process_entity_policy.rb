class ProcessEntityPolicy<ApplicationPolicy
  def show?
    true
  end

  def new?
    user_has_role? :av
  end

  def update?
    user.has_role? :av
  end

  def destroy?
    user.has_role? :av
  end

  def edit?
    user.has_role? :av
  end

  def simple?
    true
  end

  def import_auto?
    user.has_role? :av
  end

  def import_semi_auto?
    user.has_role? :av
  end
end