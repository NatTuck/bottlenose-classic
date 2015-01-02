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

ActiveRecord::Schema.define(version: 20150102004209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "chapter_id",                                       null: false
    t.string   "name",                 limit: 255,                 null: false
    t.date     "due_date",                                         null: false
    t.string   "assignment_file_name", limit: 255
    t.string   "grading_file_name",    limit: 255
    t.text     "assignment"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "points_available",                 default: 100
    t.string   "secret_dir",           limit: 255
    t.boolean  "hide_grading",                     default: false
    t.integer  "assignment_upload_id"
    t.integer  "grading_upload_id"
    t.integer  "blame_id"
    t.integer  "solution_upload_id"
  end

  add_index "assignments", ["chapter_id"], name: "index_assignments_on_chapter_id", using: :btree

  create_table "chapters", force: :cascade do |t|
    t.string   "name",       limit: 255,              null: false
    t.integer  "course_id",                           null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "notes",                  default: "", null: false
  end

  add_index "chapters", ["course_id"], name: "index_chapters_on_course_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",               limit: 255,                    null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "late_options",       limit: 255, default: "10,1,0"
    t.text     "footer"
    t.integer  "term_id"
    t.time     "questions_due_time"
    t.integer  "sub_max_size",                   default: 20,       null: false
  end

  create_table "reg_requests", force: :cascade do |t|
    t.integer  "course_id"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "course_id",                   null: false
    t.integer  "user_id",                     null: false
    t.boolean  "teacher"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "assign_score",    limit: 255
    t.string   "questions_score", limit: 255
    t.boolean  "show_in_lists"
  end

  add_index "registrations", ["course_id"], name: "index_registrations_on_course_id", using: :btree
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "assignment_id",                                   null: false
    t.integer  "user_id",                                         null: false
    t.string   "secret_dir",          limit: 255
    t.string   "file_name",           limit: 255
    t.integer  "raw_score"
    t.text     "student_notes"
    t.integer  "teacher_score"
    t.text     "teacher_notes"
    t.integer  "grading_uid"
    t.text     "grading_output"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "ignore_late_penalty",             default: false
    t.integer  "upload_id"
    t.integer  "upload_size",                     default: 0,     null: false
  end

  add_index "submissions", ["assignment_id"], name: "index_submissions_on_assignment_id", using: :btree
  add_index "submissions", ["grading_uid"], name: "index_submissions_on_grading_uid", unique: true, using: :btree
  add_index "submissions", ["user_id", "assignment_id"], name: "index_submissions_on_user_id_and_assignment_id", using: :btree
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "archived",               default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "file_name",  limit: 255
    t.string   "secret_key", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "uploads", ["secret_key"], name: "index_uploads_on_secret_key", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "email",      limit: 255, null: false
    t.string   "auth_key",   limit: 255, null: false
    t.boolean  "site_admin"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
