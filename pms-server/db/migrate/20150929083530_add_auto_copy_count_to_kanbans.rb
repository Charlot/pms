class AddAutoCopyCountToKanbans < ActiveRecord::Migration
  def change
    add_column :kanbans, :auto_copy_count, :integer, default: 1
  end
end