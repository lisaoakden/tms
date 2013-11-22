class CreateCourse < ActiveRecord::Migration
  def change
  	create_table "courses",	force: true do |t|
	    t.string   "name", limit: 128,	null: false
	    t.datetime "start_date"
	    t.datetime "end_date"
	    t.integer  "active_flag",	default: 1
	    t.string  "status", limit: 1,	default: Settings.status.new,	null: false
      t.timestamps
   	end
  end
end
