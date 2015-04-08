class ChangeQuantityOfKanbans < ActiveRecord::Migration
  def change
    change_column :kanbans,:quantity,:integer,default: 0
  end
end
