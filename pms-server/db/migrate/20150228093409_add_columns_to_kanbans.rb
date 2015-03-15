class AddColumnsToKanbans < ActiveRecord::Migration
  def change
    add_column :kanbans, :product_id, :integer,:null=>false
    add_index :kanbans,:product_id
  end
end
