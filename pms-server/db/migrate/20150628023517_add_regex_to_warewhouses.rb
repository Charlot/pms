class AddRegexToWarewhouses < ActiveRecord::Migration
  def change
    add_column :warewhouses, :regex, :string
  end
end
