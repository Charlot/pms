class CreateMachineTypes < ActiveRecord::Migration
  def change
    create_table :machine_types do |t|
      t.string :nr
      t.string :description

      t.timestamps
    end
  end
end
