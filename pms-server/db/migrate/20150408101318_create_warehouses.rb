class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
      t.string :nr
      t.string :description
      t.timestamps
    end
  end
end
