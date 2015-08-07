class AddWireFromToProcessTemplates < ActiveRecord::Migration
  def change
    add_column :process_templates,:wire_from,:integer,default: WireFromType::SEMI_AUTO  #只针对半自动步骤
  end
end
