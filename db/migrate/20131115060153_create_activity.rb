class CreateActivity < ActiveRecord::Migration
  def change
  	create_table "activities", force: true do |t|
	    t.integer  "user_id"
	    t.integer  "course_id"
	    t.integer  "subject_id"
	    t.integer  "task_id"
	    t.integer  "temp_type"
	    t.integer  "active_flag", default: 1
      t.timestamps
  	end
  end
end
