class ChangeOptimiseIndexType < ActiveRecord::Migration
  def change
    change_column :production_order_items, :optimise_index, :float, default: 0
  end
end
