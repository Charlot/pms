class ProcessTemplatePolicy<ApplicationPolicy
  def update?
    user.av?
  end

  def template?
    true
  end

  def import
    update?
  end

  def autoimport?
    update?
  end

  def semiautoimport?
    update?
  end

  def manual_import?
    update?
  end
end