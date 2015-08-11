class AddCustomValueReferencesToProcessParts < ActiveRecord::Migration
  def change
    add_reference :process_parts, :custom_value, index: true
  end
end
