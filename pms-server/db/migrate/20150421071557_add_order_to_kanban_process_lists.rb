class AddOrderToKanbanProcessLists < ActiveRecord::Migration
  def change
    add_column :kanban_process_entities,:position,:integer,default:0
  end
end
