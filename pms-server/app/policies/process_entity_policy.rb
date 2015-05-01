class ProcessEntityPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
  end

  def simple?
    true
  end

  def import_auto?
    update?
  end

  def import_semi_auto?
    update?
  end

  def export_auto?
    true
  end

  def export_semi?
    true
  end

  def export_unused?
    true
  end
end