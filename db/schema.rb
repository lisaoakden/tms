# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131105042634) do

  create_table "conclusions", force: true do |t|
    t.integer "enroll_id",           null: false
    t.string  "content",   limit: 4, null: false
    t.text    "comment",             null: false
  end

  add_index "conclusions", ["enroll_id"], name: "fk_Enroll_idx", using: :btree

  create_table "course_subjects", force: true do |t|
    t.integer "course_id",  null: false
    t.integer "subject_id", null: false
  end

  add_index "course_subjects", ["course_id"], name: "fk_Course_Subject_1", using: :btree
  add_index "course_subjects", ["subject_id"], name: "fk_Course_Subject_2", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name",       limit: 45, null: false
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "custom_courses", force: true do |t|
    t.integer "course_sub_id", null: false
    t.integer "task_id",       null: false
  end

  add_index "custom_courses", ["course_sub_id"], name: "fk_Course_Subject_idx", using: :btree
  add_index "custom_courses", ["task_id"], name: "fk_Task_idx", using: :btree

  create_table "enrollment_subjects", force: true do |t|
    t.integer "enroll_id",            null: false
    t.string  "name",      limit: 45, null: false
    t.string  "status",    limit: 11, null: false
  end

  add_index "enrollment_subjects", ["enroll_id"], name: "fk_Enroll_idx", using: :btree

  create_table "enrollment_tasks", force: true do |t|
    t.integer "enroll_subject_id",            null: false
    t.string  "name",              limit: 45, null: false
    t.string  "status",            limit: 11, null: false
  end

  add_index "enrollment_tasks", ["enroll_subject_id"], name: "fk_Subject_idx", using: :btree

  create_table "enrollments", force: true do |t|
    t.integer  "user_id",                     null: false
    t.integer  "course_id",                   null: false
    t.datetime "joined_date"
  end

  add_index "enrollments", ["course_id"], name: "fk_Enrollments_2", using: :btree
  add_index "enrollments", ["user_id"], name: "fk_Enrollments_1", using: :btree

  create_table "subjects", force: true do |t|
    t.string "name",        limit: 45, null: false
    t.text   "description",            null: false
  end

  create_table "tasks", force: true do |t|
    t.integer "subject_id",             null: false
    t.string  "name",        limit: 45
    t.string  "description", limit: 45
  end

  add_index "tasks", ["subject_id"], name: "fk_Tasks_1", using: :btree

  create_table "users", force: true do |t|
    t.string "name",            limit: 45, null: false
    t.string "email",           limit: 45, null: false
    t.string "password_digest", limit: 200, null: false
    t.string "remember_token"
  end

  add_index "users", ["email"], name: "email_UNIQUE", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
