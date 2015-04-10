class AddColumnsToParts < ActiveRecord::Migration
  def change
    add_column :parts,:color,:string
    add_column :parts,:color_desc,:string
    add_column :parts,:component_type,:string
    add_column :parts,:cross_section,:float, default: 0
  end
end
