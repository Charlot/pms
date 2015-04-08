class RemoveVersionFromKanbans < ActiveRecord::Migration
  def change
    remove_column :kanbans, :version
    remove_column :kanbans, :task_time
  end
end
