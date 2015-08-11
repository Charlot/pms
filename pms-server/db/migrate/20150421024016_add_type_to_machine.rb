class AddTypeToMachine < ActiveRecord::Migration
  def change
    add_column :machines,:machine_type_id,:integer
    add_index :machines,:machine_type_id
  end
end
