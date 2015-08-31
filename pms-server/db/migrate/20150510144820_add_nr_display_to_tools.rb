class AddNrDisplayToTools < ActiveRecord::Migration
  def change
    add_column :tools, :nr_display, :string
  end
end
