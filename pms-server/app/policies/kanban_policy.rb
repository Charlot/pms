class KanbanPolicy<ApplicationPolicy
  def update?
    user.av? || user.system?
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
    user.av? || user.cutting?
  end

  def history?
    true
  end

  def release?
    user.av? || user.system?
  end

  def lock?
    user.av? || user.system?
  end

  def discard?
    user.av? || user.system?
  end

  def add_routing_template?
    user.av? || user.system?
  end

  def import?
    user.av? || user.system?
  end

  def import_to_scan?
    user.av? || user.cutting? || user.system?
  end

  def import_to_get_kanban_list
    true
  end

  def scan_finish?
    #user.has_any_role? :av,:cutting
    user.av? ||user.cutting? || user.system?
  end

  def management?
    user.av? || user.system?
  end

  def scan?
    user.av? ||user.cutting? || user.system?
  end

  def panel?
    user.av?||user.cutting? || user.system?
  end

  def import_update_quantity?
    user.av? || user.admin? || user.system?
  end
end