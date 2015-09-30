class AddIndexesToKanbans < ActiveRecord::Migration
  def change
    add_index :kanbans, :state
    add_index :kanbans, :des_storage
  end
end
