class CreatePartProcessEntities < ActiveRecord::Migration
  def change
    create_table :part_process_entities do |t|
      t.integer :part_id
      t.integer :process_entity_id
      t.timestamps
    end
    add_index :part_process_entities,:part_id
    add_index :part_process_entities,:process_entity_id
  end
end