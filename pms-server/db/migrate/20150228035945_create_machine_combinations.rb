class CreateMachineCombinations < ActiveRecord::Migration
  def change
    create_table :machine_combinations do |t|
      t.integer :w1
      t.integer :t1
      t.integer :t2
      t.integer :s1
      t.integer :s2
      t.integer :wd1
      t.integer :w2
      t.integer :t3
      t.integer :t4
      t.integer :s3
      t.integer :s4
      t.integer :wd2
      t.references :machine, index: true

      t.timestamps
    end
  end
end
