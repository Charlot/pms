class CreateProcessTemplates < ActiveRecord::Migration
  def change
    create_table :process_templates do |t|
      t.string :code
      t.integer :type
      t.string :name
      t.text :template
      t.text :description

      t.timestamps
    end
    add_index :process_templates, :code
    add_index :process_templates, :type
  end
end
