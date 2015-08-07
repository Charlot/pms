class AddWireLentghTimeToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :wire_length_time, :float, default: 2
  end
end
