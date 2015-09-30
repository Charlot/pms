class AddLockedToTools < ActiveRecord::Migration
  def change
    add_column :tools, :locked, :boolean, default: false
  end
end
