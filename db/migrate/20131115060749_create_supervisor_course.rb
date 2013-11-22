class CreateSupervisorCourse < ActiveRecord::Migration
  def change
  	create_table "supervisor_courses", force: true do |t|
	    t.integer  "supervisor_id"
	    t.integer  "course_id"
	    t.integer  "active_flag", default: 1
	    t.timestamps
	  end
  end
end
