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

ActiveRecord::Schema.define(version: 20141230025338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id", null: false
    t.integer  "user_id",     null: false
    t.string   "answer",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attempts"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.integer  "chapter_id",                           null: false
    t.string   "name",                                 null: false
    t.date     "due_date",                             null: false
    t.string   "assignment_file_name"
    t.string   "grading_file_name"
    t.text     "assignment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_available",     default: 100
    t.string   "secret_dir"
    t.boolean  "hide_grading",         default: false
    t.integer  "assignment_upload_id"
    t.integer  "grading_upload_id"
    t.integer  "blame_id"
    t.integer  "solution_upload_id"
  end

  add_index "assignments", ["chapter_id"], name: "index_assignments_on_chapter_id", using: :btree

  create_table "chapters", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "course_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["course_id"], name: "index_chapters_on_course_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "late_options",       default: "10,1,0"
    t.text     "footer"
    t.integer  "term_id"
    t.time     "questions_due_time"
    t.integer  "sub_max_size",       default: 20,       null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "chapter_id",    null: false
    t.text     "video"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.date     "questions_due"
  end

  add_index "lessons", ["chapter_id"], name: "index_lessons_on_chapter_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "lesson_id",      null: false
    t.text     "question"
    t.string   "correct_answer"
    t.text     "explanation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "question_form"
    t.string   "name"
  end

  add_index "questions", ["lesson_id"], name: "index_questions_on_lesson_id", using: :btree

  create_table "reg_requests", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "email"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "course_id",       null: false
    t.integer  "user_id",         null: false
    t.boolean  "teacher"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assign_score"
    t.string   "questions_score"
    t.boolean  "show_in_lists"
  end

  add_index "registrations", ["course_id"], name: "index_registrations_on_course_id", using: :btree
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "assignment_id",                       null: false
    t.integer  "user_id",                             null: false
    t.string   "secret_dir"
    t.string   "file_name"
    t.integer  "raw_score"
    t.text     "student_notes"
    t.integer  "teacher_score"
    t.text     "teacher_notes"
    t.integer  "grading_uid"
    t.text     "grading_output"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ignore_late_penalty", default: false
    t.integer  "upload_id"
    t.integer  "upload_size",         default: 0,     null: false
  end

  add_index "submissions", ["assignment_id"], name: "index_submissions_on_assignment_id", using: :btree
  add_index "submissions", ["grading_uid"], name: "index_submissions_on_grading_uid", unique: true, using: :btree
  add_index "submissions", ["user_id", "assignment_id"], name: "index_submissions_on_user_id_and_assignment_id", using: :btree
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "name"
    t.boolean  "archived",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "file_name"
    t.string   "secret_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["secret_key"], name: "index_uploads_on_secret_key", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.string   "auth_key",   null: false
    t.boolean  "site_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
