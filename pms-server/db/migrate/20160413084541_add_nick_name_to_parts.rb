class AddNickNameToParts < ActiveRecord::Migration
  def change
    add_column :parts, :nick_name, :string
  end
end
