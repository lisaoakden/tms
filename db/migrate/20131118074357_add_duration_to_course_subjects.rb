class AddDurationToCourseSubjects < ActiveRecord::Migration
  def change
  	add_column :course_subjects, :duration, :integer
  end
end