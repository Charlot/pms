class AddTypeToKanbans < ActiveRecord::Migration
  def change
    add_column :kanbans,:ktype,:integer
  end
end
