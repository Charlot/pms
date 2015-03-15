class AddWireLengthToKanbans < ActiveRecord::Migration
  def change
    add_column :kanbans, :wire_length,:float,default: 0.0
  end
end
