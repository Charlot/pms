class AddFieldsToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :print_time, :float,default:0
    add_column :machines, :seal_time, :float,default:0
    add_column :machines, :terminal_time, :float,default:0
    add_column :machines, :wire_time, :float,default:0
  end
end
