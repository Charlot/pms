class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :nr
      t.references :warehouse, index: true

      t.timestamps
    end
  end
end
