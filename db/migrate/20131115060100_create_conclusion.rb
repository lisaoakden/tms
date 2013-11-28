class CreateConclusion < ActiveRecord::Migration
  def change
  	create_table "conclusions", force: true do |t|
	    t.integer  "enrollment_id"
	    t.string   "content", limit: 4, null: false
	    t.text     "comment", null: false
	    t.integer  "active_flag", default: 1
      t.timestamps
  	end
  	add_index "conclusions", ["enrollment_id"], name: "fk_Enroll_idx", using: :btree
  end
end
