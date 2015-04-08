class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :nr
      t.string :name
      t.string :description
      t.references :resource_group, index: true

      t.timestamps
    end
    add_index :machines, :nr
  end
end
