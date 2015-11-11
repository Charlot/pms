class CreateMeasuredValueRecords < ActiveRecord::Migration
  def change
    create_table :measured_value_records do |t|
      t.string :production_order_id
      t.string :part_id
      t.float :crimp_height_1
      t.float :crimp_height_2
      t.float :crimp_height_3
      t.float :crimp_height_4
      t.float :crimp_height_5
      t.float :crimp_width
      t.float :i_crimp_heigth
      t.float :i_crimp_width
      t.float :pulloff_value
      t.string :note

      t.timestamps
    end
    add_index :measured_value_records, :production_order_id
  end
end
