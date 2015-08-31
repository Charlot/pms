class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :detail
      t.references :warehouse, index: true

      t.timestamps
    end
  end
end
