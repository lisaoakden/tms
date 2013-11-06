class AddCurrentCourseIdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :current_course_id, :integer
  end
end
