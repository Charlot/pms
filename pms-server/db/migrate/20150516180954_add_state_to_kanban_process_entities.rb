class AddStateToKanbanProcessEntities < ActiveRecord::Migration
  def change
    add_column :kanban_process_entities, :state, :integer,default: ProductionOrderItemState::INIT
  end
end