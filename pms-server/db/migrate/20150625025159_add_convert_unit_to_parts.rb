class AddConvertUnitToParts < ActiveRecord::Migration
  def change
    add_column :parts, :convert_unit, :decimal
  end
end
