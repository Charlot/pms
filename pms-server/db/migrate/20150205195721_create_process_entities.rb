class CreateProcessEntities < ActiveRecord::Migration
  def change
    create_table :process_entities do |t|
      t.string :nr, null: false
      t.string :name
      t.text :description
      t.float :stand_time, default: 0
      t.references :process_template, index: true
      t.references :workstation_type, index: true
      t.references :cost_center, index: true

      t.timestamps
    end
  end
end
