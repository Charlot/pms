class CreatePartPositions < ActiveRecord::Migration
  def change
    create_table :part_positions do |t|
      t.references :part
      t.string :storage
      t.string :description
      t.timestamps
    end
  end
end
