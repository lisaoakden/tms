class CreateCourseSubject < ActiveRecord::Migration
  def change
  	create_table "course_subjects", force: true do |t|
	    t.integer  "course_id"
	    t.integer  "subject_id"
	    t.string   "status", limit: 1, default: Settings.status.new, null: false
	    t.integer  "active_flag", default: 1
	    t.datetime "start_date"
	    t.integer  "duration"
	    t.datetime "end_date"
      t.timestamps
 	  end

	  add_index "course_subjects", ["course_id"], name: "fk_Course_Subject_1", using: :btree
	  add_index "course_subjects", ["subject_id"], name: "fk_Course_Subject_2", using: :btree

  end
end
