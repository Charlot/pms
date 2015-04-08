class CreateKanbans < ActiveRecord::Migration
  def change
    create_table :kanbans do |t|
      t.string :nr, :null => false
      t.string :remark
      t.float :quantity, :default => 0
      t.float :safety_stock, :default => 0 ,:null => false
      t.float :task_time,:default => 0
      t.integer :copies,:default => 0 #份数
      t.integer :state, :default => 0
      t.integer :version, :default => 1
      t.string :source_warehouse #是否需要创建一个ActiveRecord来映射WMS中的数据？
      t.string :source_storage
      t.string :des_warehouse
      t.string :des_storage
      t.references :part,:null => false
      t.datetime :print_time
      t.timestamps
    end
    add_index :kanbans, :nr
    add_index :kanbans, :part_id
  end
end
