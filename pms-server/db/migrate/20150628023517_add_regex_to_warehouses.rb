class AddRegexToWarehouses < ActiveRecord::Migration
  def change
    add_column :warehouses, :regex, :string
  end
end
