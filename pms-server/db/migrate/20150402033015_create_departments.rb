class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :description
      t.string :code
      t.integer :parent_id

      t.timestamps
    end
    add_index :departments, :parent_id
  end
end
