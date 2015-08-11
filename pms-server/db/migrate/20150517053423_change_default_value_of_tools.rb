class ChangeDefaultValueOfTools < ActiveRecord::Migration
  def up
    change_column_default :tools, :mnt, 0
    change_column_default :tools, :tol, 0
  end

  def down

  end
end
