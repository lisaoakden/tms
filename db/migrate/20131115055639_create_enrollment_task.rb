class CreateEnrollmentTask < ActiveRecord::Migration
  def change
   	create_table "enrollment_tasks", force: true do |t|
	    t.integer  "subject_id"
	    t.integer  "task_id"
	    t.integer  "enrollment_subject_id",                        null: false
	    t.string   "status",                limit: 11,             null: false
	    t.integer  "active_flag",                      default: 1
      t.timestamps
  	end
  	add_index "enrollment_tasks", ["enrollment_subject_id"], name: "fk_Subject_idx", using: :btree
  end
end
