class CreateKanbanProcessEntities < ActiveRecord::Migration
  def change
    create_table :kanban_process_entities do |t|
      t.references :kanban
      t.references :process_entity
      t.timestamps
    end
    add_index :kanban_process_entities,:kanban_id
    add_index :kanban_process_entities,:process_entity_id
  end
end
