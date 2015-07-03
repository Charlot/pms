class AddUnitToParts < ActiveRecord::Migration
  def change
    add_column :parts, :addr, :string
    add_column :parts, :unit, :string
    add_column :parts, :desc1, :string
    add_column :parts, :pno, :string
  end
end
