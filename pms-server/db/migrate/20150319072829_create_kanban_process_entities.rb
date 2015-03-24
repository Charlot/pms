class CreateKanbanProcessEntities < ActiveRecord::Migration
  def change
    drop_table :kanban_process_entities if table_exists? :kanban_process_entities

    create_table :kanban_process_entities do |t|
      t.references :kanban, index: true
      t.references :process_entity, index: true

      t.timestamps
    end
  end
end
