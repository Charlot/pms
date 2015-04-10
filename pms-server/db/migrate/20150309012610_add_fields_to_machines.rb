class AddFieldsToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :print_time, :float, default: 45
    add_column :machines, :seal_time, :float, default: 40
    add_column :machines, :terminal_time, :float, default: 15
    add_column :machines, :wire_time, :float, default: 5
    add_column :machines, :status, :integer, default: 0
    add_column :machines, :ip, :string
  end
end
