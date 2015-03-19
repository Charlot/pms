class CreateKanbanProcessEntities < ActiveRecord::Migration
  def change
    create_table :kanban_process_entities do |t|
      t.references :Kanban, index: true
      t.references :ProcessEntity, index: true

      t.timestamps
    end
  end
end
