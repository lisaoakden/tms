class CreateSubject < ActiveRecord::Migration
  def change
  	create_table "subjects", force: true do |t|
	    t.string   "name", limit: 128, null: false
	    t.text     "description", null: false
	    t.integer  "duration"
	    t.integer  "active_flag", default: 1
      t.timestamps
  	end
  end
end
