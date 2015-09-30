class AddStateAsIndexToKanbanProcessEntities < ActiveRecord::Migration
  def change
    add_index :kanban_process_entities, :state
  end
end
