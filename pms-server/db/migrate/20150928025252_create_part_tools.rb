class CreatePartTools < ActiveRecord::Migration
  def change
    create_table :part_tools do |t|
      t.references :part, index: true
      t.references :tool, index: true

      t.timestamps
    end
  end
end
