class KanbanPolicy<ApplicationPolicy
  def update?
    user.av?
  end

  def create?
    user.av?
  end

  def manage_routing?
    update?
  end

  def add_process_entities?
    update?
  end

  def delete_process_entities?
    update?
  end

  def destroy?
    user.av?
  end

  def finish_production?
    user.has_any_role? :av,:cutting
  end

  def history?
    true
  end

  def release?
    user.av?
  end

  def lock?
    user.av?
  end

  def discard?
    user.av?
  end

  def add_routing_template?
    user.av?
  end

  def import?
    user.av?
  end

  def import_to_scan?
    user.has_any_role? :av,:cutting
  end

  def import_to_get_kanban_list
    true
  end

  def scan_finish?
    #user.has_any_role? :av,:cutting
    user.av? || user.admin?
  end

  def management?
    user.av?
  end

  def scan?
    user.av? || user.admin?
  end

  def panel?
    user.av? || user.admin?
  end
end