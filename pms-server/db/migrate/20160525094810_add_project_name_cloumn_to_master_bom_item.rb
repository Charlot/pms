class AddProjectNameCloumnToMasterBomItem < ActiveRecord::Migration
  def change
    add_column :master_bom_items, :project_name, :string
  end
end
