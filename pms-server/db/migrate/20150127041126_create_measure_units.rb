class CreateMeasureUnits < ActiveRecord::Migration
  def change
    create_table :measure_units do |t|
      t.string :code
      t.string :describe
      t.string :cn
      t.string :en

      t.timestamps
    end
    add_index :measure_units, :code
  end
end
