class CreateEnrollment < ActiveRecord::Migration
  def change
  	create_table "enrollments", force: true do |t|
	    t.integer  "user_id"
	    t.integer  "course_id"
	    t.datetime "joined_date"
	    t.integer  "status",                  null: false
	    t.integer  "active_flag", default: 1
      t.timestamps
  	end
	  add_index "enrollments", ["course_id"], name: "fk_Enrollments_2", using: :btree
	  add_index "enrollments", ["user_id"], name: "fk_Enrollments_1", using: :btree
  end
end