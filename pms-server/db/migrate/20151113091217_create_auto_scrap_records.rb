class CreateAutoScrapRecords < ActiveRecord::Migration
  def change
    create_table :auto_scrap_records do |t|
      t.string :scrap_id
      t.string :order_nr
      t.string :kanban_nr
      t.string :machine_nr
      t.string :part_nr
      t.decimal :qty, :precision => 15, :scale => 10
      t.string :user_id

      t.timestamps
    end
    add_index :auto_scrap_records, :scrap_id
    add_index :auto_scrap_records, :order_nr
  end
end
