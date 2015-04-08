class RemoveWireLengthFromKanbans < ActiveRecord::Migration
  def change
    remove_column :kanbans,:wire_length
  end
end
