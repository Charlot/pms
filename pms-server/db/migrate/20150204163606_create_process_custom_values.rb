class CreateProcessCustomValues < ActiveRecord::Migration
  def change
    create_table :process_custom_values do |t|
      t.string :customized_type
      t.integer :customized_id
      t.integer :custom_field_id
      t.text :value

      t.timestamps
    end
    add_index :process_custom_values, [:customized_type, :customized_id]
    add_index :process_custom_values, :custom_field_id
  end
end
