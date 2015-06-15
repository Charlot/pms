class AddRemarkToParts < ActiveRecord::Migration
  def change
    add_column :parts, :remark, :string
  end
end
