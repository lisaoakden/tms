class CreateCourseSubjectTask < ActiveRecord::Migration
  def change
  	create_table "course_subject_tasks", force: true do |t|
	    t.integer "course_subject_id", null: false
	    t.integer "subject_id",       null: false
	    t.integer "task_id",       null: false
	    t.integer "active_flag",               default: 1
      t.timestamps
	  end
  end
end
