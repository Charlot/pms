class AddProductIdAndWireIdToProcessEntities < ActiveRecord::Migration
  def change
    add_column :process_entities,:product_id,:integer,:null => false
    add_index :process_entities,:product_id
    add_column :process_entities,:part_id,:integer,:null => false
    add_index :process_entities,:part_id
  end
end
