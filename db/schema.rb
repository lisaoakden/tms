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

ActiveRecord::Schema.define(version: 0) do

  create_table "Conclusion", force: true do |t|
    t.string  "content",   limit: 4, null: false
    t.text    "comment",             null: false
    t.integer "enroll_id",           null: false
  end

  add_index "Conclusion", ["enroll_id"], name: "fk_Enroll_idx", using: :btree

  create_table "Course_Subject", force: true do |t|
    t.integer "course_id",  null: false
    t.integer "subject_id", null: false
  end

  add_index "Course_Subject", ["course_id"], name: "fk_Course_Subject_1", using: :btree
  add_index "Course_Subject", ["subject_id"], name: "fk_Course_Subject_2", using: :btree

  create_table "Courses", force: true do |t|
    t.string   "name",       limit: 45, null: false
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "Customers_Course", force: true do |t|
    t.integer "course_sub_id", null: false
    t.integer "task_id",       null: false
  end

  add_index "Customers_Course", ["course_sub_id"], name: "fk_Course_Subject_idx", using: :btree
  add_index "Customers_Course", ["task_id"], name: "fk_Task_idx", using: :btree

  create_table "Enroll_Subjects", force: true do |t|
    t.integer "enroll_id",            null: false
    t.string  "name",      limit: 45, null: false
    t.string  "status",    limit: 11, null: false
  end

  add_index "Enroll_Subjects", ["enroll_id"], name: "fk_Enroll_idx", using: :btree

  create_table "Enrollment_Task", force: true do |t|
    t.string  "name",              limit: 45, null: false
    t.string  "status",            limit: 11, null: false
    t.integer "enroll_subject_id",            null: false
  end

  add_index "Enrollment_Task", ["enroll_subject_id"], name: "fk_Subject_idx", using: :btree

  create_table "Enrollments", force: true do |t|
    t.integer  "user_id",                     null: false
    t.integer  "course_id",                   null: false
    t.datetime "joined_date"
    t.boolean  "current",     default: false
  end

  add_index "Enrollments", ["course_id"], name: "fk_Enrollments_2", using: :btree
  add_index "Enrollments", ["user_id"], name: "fk_Enrollments_1", using: :btree

  create_table "Subjects", force: true do |t|
    t.string "name",        limit: 45, null: false
    t.text   "description",            null: false
  end

  create_table "Tasks", force: true do |t|
    t.integer "subject_id",             null: false
    t.string  "name",        limit: 45
    t.string  "description", limit: 45
  end

  add_index "Tasks", ["subject_id"], name: "fk_Tasks_1", using: :btree

  create_table "Users", force: true do |t|
    t.string "name",            limit: 45, null: false
    t.string "email",           limit: 45, null: false
    t.string "password_digest", limit: 45, null: false
    t.string "role",            limit: 10, null: false
  end

  add_index "Users", ["email"], name: "email_UNIQUE", unique: true, using: :btree

end
