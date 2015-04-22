class KanbanPolicy<ApplicationPolicy
  def new?
    user.has_role? :av
  end

  def update?
    user.has_role? :av
  end

  def manage_routing?
    user.has_role? :av
  end

  def add_process_entities?
    user.has_role? :av
  end

  def delete_process_entities?
    user.has_role? :av
  end

  def destroy?
    user.has_role? :av
  end

  def finish_production?
    user.has_any_role? :av,:cutting
  end

  def history?
    true
  end

  def release?
    user.has_role? :av
  end

  def lock?
    user.has_role? :av
  end

  def discard?
    user.has_role? :av
  end

  def add_routing_template?
    user.has_role? :av
  end

  def import?
    user.has_role? :av
  end

  def import_to_scan?
    user.has_any_role? :av,:cutting
  end

  def import_to_get_kanban_list
    true
  end

  def scan_finish?
    user.has_any_role? :av,:cutting
  end

  def management?
    user.has_role? :av
  end

  def scan?
    user.has_any_role? :av,:cutting
  end

  def panel?
    user.has_any_role? :av,:cutting
  end
end