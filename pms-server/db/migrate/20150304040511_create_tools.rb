class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :nr
      t.references :resource_group, index: true
      t.references :part, index: true
      t.integer :mnt
      t.integer :used_days
      t.integer :rql
      t.integer :tol
      t.datetime :rql_date

      t.timestamps
    end
    add_index :tools, :nr
  end
end
