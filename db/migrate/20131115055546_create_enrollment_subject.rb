class CreateEnrollmentSubject < ActiveRecord::Migration
  def change
  	create_table "enrollment_subjects",  force: true do |t|
	    t.integer  "subject_id"
      t.integer  "user_id"
      t.integer  "course_id"
	    t.integer  "enrollment_id"
	    t.string  "status",                limit: 1, default: "N", null: false
	    t.datetime "start_date"
	    t.integer  "active_flag",          default: 1
      t.timestamps
  	end
  	add_index "enrollment_subjects", ["enrollment_id"], name: "fk_Enroll_idx", using: :btree
  end
end
