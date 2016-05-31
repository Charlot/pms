class AddProjectNameCloumnToMasterBomItem < ActiveRecord::Migration
  def change
    add_column :master_bom_items, :project_name, :string
    add_index :master_bom_items, :project_name
  end
end
