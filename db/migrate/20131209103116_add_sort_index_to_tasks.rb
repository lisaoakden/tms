class AddSortIndexToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :sort_index, :integer
  end
end
