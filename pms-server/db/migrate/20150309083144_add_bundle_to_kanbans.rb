class AddBundleToKanbans < ActiveRecord::Migration
  def change
    add_column :kanbans,:bundle,:integer,default: 0
  end
end
