class CreateUser < ActiveRecord::Migration
  def change
  	create_table "users", force: true do |t|
	    t.string   "name", limit: 45, null: false
	    t.string   "email", limit: 45, null: false
	    t.string   "password_digest", limit: 200, null: false
	    t.string   "remember_token"
	    t.integer  "current_course_id"
	    t.integer  "active_flag", default: 1
      t.timestamps
  	end
    add_index "users", ["email"], name: "email_UNIQUE", unique: true, using: :btree
    add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end
end
