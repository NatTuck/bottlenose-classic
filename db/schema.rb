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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121018015721) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id", :null => false
    t.integer  "user_id",     :null => false
    t.string   "answer",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "attempts"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "assignments", :force => true do |t|
    t.integer  "chapter_id",                              :null => false
    t.string   "name",                                    :null => false
    t.date     "due_date",                                :null => false
    t.string   "assignment_file_name"
    t.string   "grading_file_name"
    t.text     "assignment"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "points_available",     :default => 100
    t.string   "secret_dir"
    t.boolean  "hide_grading",         :default => false
  end

  add_index "assignments", ["chapter_id"], :name => "index_assignments_on_chapter_id"

  create_table "chapters", :force => true do |t|
    t.string   "name",          :null => false
    t.integer  "course_id",     :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "questions_due"
  end

  add_index "chapters", ["course_id"], :name => "index_chapters_on_course_id"

  create_table "courses", :force => true do |t|
    t.string   "name",                               :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "late_options", :default => "10,1,0"
  end

  create_table "lessons", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "chapter_id", :null => false
    t.text     "video"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lessons", ["chapter_id"], :name => "index_lessons_on_chapter_id"

  create_table "questions", :force => true do |t|
    t.integer  "lesson_id",      :null => false
    t.text     "question"
    t.string   "correct_answer"
    t.text     "explanation"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "question_form"
    t.string   "name"
  end

  add_index "questions", ["lesson_id"], :name => "index_questions_on_lesson_id"

  create_table "registrations", :force => true do |t|
    t.integer  "course_id",  :null => false
    t.integer  "user_id",    :null => false
    t.boolean  "teacher"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "registrations", ["course_id"], :name => "index_registrations_on_course_id"
  add_index "registrations", ["user_id"], :name => "index_registrations_on_user_id"

  create_table "submissions", :force => true do |t|
    t.integer  "assignment_id",                          :null => false
    t.integer  "user_id",                                :null => false
    t.string   "secret_dir"
    t.string   "file_name"
    t.integer  "raw_score"
    t.text     "student_notes"
    t.integer  "teacher_score"
    t.text     "teacher_notes"
    t.integer  "grading_uid"
    t.text     "grading_output"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "ignore_late_penalty", :default => false
  end

  add_index "submissions", ["assignment_id"], :name => "index_submissions_on_assignment_id"
  add_index "submissions", ["grading_uid"], :name => "index_submissions_on_grading_uid", :unique => true
  add_index "submissions", ["user_id"], :name => "index_submissions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.string   "auth_key",   :null => false
    t.boolean  "site_admin"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
