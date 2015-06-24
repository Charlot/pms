class AddCodeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :code, :string
  end
end
