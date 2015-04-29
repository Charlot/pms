class AddRemarkToProcessEntities < ActiveRecord::Migration
  def change
    add_column :process_entities, :remark, :text
  end
end
