class CreateWarehouseRegexes < ActiveRecord::Migration
  def change
    create_table :warehouse_regexes do |t|
      t.string :regex
      t.string :warehouse_nr
      t.string :desc

      t.timestamps
    end
  end
end
