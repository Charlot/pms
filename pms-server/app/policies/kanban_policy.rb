class KanbanPolicy<ApplicationPolicy
  def update?
    true
    # user.av? || user.system?
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

  def finish_production?
    # user.av? || user.cutting?
    true
  end

  def history?
    true
  end

  def release?
    user.av?
    true
  end

  def lock?
    user.av?
    true
  end

  def discard?
    user.av?
    true
  end

  def add_routing_template?
    user.av?
    true
  end

  def import?
    user.av?
    true
  end

  def import_to_scan?
    user.has_any_role? :av,:cutting
    true
  end

  def import_to_get_kanban_list
    true
  end

  def scan_finish?
    #user.has_any_role? :av,:cutting
    user.av? || user.admin?
    true
  end

  def management?
    user.av?
    true
  end

  def scan?
    user.av? || user.admin?
    true
  end

  def panel?
    user.av? || user.admin?
    true
  end
end