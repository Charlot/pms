class CreateCrimpConfigurationItems < ActiveRecord::Migration
  def change
    create_table :crimp_configuration_items do |t|
      t.integer :crimp_configuration_id
      t.string :side
      t.float :min_pulloff
      t.float :crimp_height
      t.float :crimp_height_iso
      t.float :crimp_width
      t.float :crimp_width_iso
      t.float :i_crimp_height
      t.float :i_crimp_height_iso
      t.float :i_crimp_width
      t.float :i_crimp_width_iso, default: 0

      t.timestamps
    end
    add_index :crimp_configuration_items, :crimp_configuration_id
  end
end
