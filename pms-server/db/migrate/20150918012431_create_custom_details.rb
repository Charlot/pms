class CreateCustomDetails < ActiveRecord::Migration
  def change
    create_table :custom_details do |t|
      t.string :part_nr_from
      t.string :part_nr_to
      t.string :custom_nr

      t.timestamps
    end
    add_index :custom_details, :custom_nr
  end
end
