class AddColumnsToKanban < ActiveRecord::Migration
  def change
    add_column :kanbans,:remark2,:string,default: ""
  end
end
