class CreateOeeCodes < ActiveRecord::Migration
  def change
    create_table :oee_codes do |t|
      t.string :nr
      t.string :description
      t.timestamps
    end
  end
end
