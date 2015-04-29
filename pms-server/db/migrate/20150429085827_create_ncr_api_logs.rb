class CreateNcrApiLogs < ActiveRecord::Migration
  def change
    create_table :ncr_api_logs do |t|
      t.string :machine_nr
      t.string :order_item_nr
      t.integer :log_type
      t.integer :order_item_state
      t.float :order_item_qty
      t.text :params_detail
      t.text :return_detail

      t.timestamps
    end
  end
end
