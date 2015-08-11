class AddConvertUnitToParts < ActiveRecord::Migration
  def change
    add_column :parts, :convert_unit, :decimal,default:1
  end
end
