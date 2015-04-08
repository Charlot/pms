class CreateMachineScopes < ActiveRecord::Migration
  def change
    create_table :machine_scopes do |t|
      t.boolean :w1, default: false
      t.boolean :t1, default: false
      t.boolean :t2, default: false
      t.boolean :s1, default: false
      t.boolean :s2, default: false
      t.boolean :wd1, default: false
      t.boolean :w2, default: false
      t.boolean :t3, default: false
      t.boolean :t4, default: false
      t.boolean :s3, default: false
      t.boolean :s4, default: false
      t.boolean :wd2, default: false
      t.references :machine, index: true

      t.timestamps
    end
  end
end
