class AddFieldsToParts < ActiveRecord::Migration
  def change
    add_column :parts, :description, :text
  end
end
