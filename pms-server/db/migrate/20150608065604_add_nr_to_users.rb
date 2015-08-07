class AddNrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nr, :string
  end
end
