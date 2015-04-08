class DeletePartIdFromKanbans < ActiveRecord::Migration
  def change
    remove_column :kanbans,:part_id
  end
end
