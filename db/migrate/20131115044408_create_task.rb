class CreateTask < ActiveRecord::Migration
  def change
  	create_table "tasks",        force: true do |t|
	    t.integer  "subject_id",   null: false
	    t.string   "name",         limit: 128
	    t.string   "description",  limit: 512
	    t.integer  "active_flag",  default: 1
      t.timestamps
  	end
  	add_index "tasks", ["subject_id"], name: "fk_Tasks_1", using: :btree
  end
end
