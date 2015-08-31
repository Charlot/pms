class AddPartIdToStorages < ActiveRecord::Migration
  def change
    add_column :storages, :part_id,:integer, index: true
    add_column :storages, :position_id,:integer, index: true
    add_column :storages, :quantity,:integer
  end
end
