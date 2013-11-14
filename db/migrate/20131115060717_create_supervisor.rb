class CreateSupervisor < ActiveRecord::Migration
  def change
  	create_table "supervisors", force: true do |t|
	    t.string   "name"
	    t.string   "email"
	    t.string   "password_digest"
	    t.string   "remember_token"
	    t.integer  "active_flag",     default: 1
	    t.timestamps
  	end
  end
end
