class AddToolToCrimpConfgiuration < ActiveRecord::Migration
  def change
    add_column :crimp_configurations, :tool_id, :integer
  end
end
