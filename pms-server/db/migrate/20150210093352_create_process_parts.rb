class CreateProcessParts < ActiveRecord::Migration
  def change
    create_table :process_parts do |t|
      t.float :quantity, default: 0
      t.references :part, index: true
      t.references :process_entity, index: true
      t.integer :unit

      t.timestamps
    end
  end
end
