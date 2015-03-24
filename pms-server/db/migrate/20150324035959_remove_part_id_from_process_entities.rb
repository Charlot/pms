class RemovePartIdFromProcessEntities < ActiveRecord::Migration
  def change
    if column_exists? :process_entities,:part_id
      remove_column :process_entities,:part_id
    end
  end
end
