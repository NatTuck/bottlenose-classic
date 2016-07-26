class InitSchema < ActiveRecord::Migration
  def up
    
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    
    create_table "assignments", force: :cascade do |t|
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
      t.string   "tar_key"
      t.integer  "bucket_id"
      t.integer  "course_id",                            null: false
      t.integer  "team_set_id"
    end
    
    create_table "best_subs", force: :cascade do |t|
      t.integer "user_id",       null: false
      t.integer "assignment_id", null: false
      t.integer "submission_id", null: false
      t.float   "score",         null: false
    end
    
    create_table "buckets", force: :cascade do |t|
      t.integer  "course_id",                null: false
      t.string   "name",                     null: false
      t.float    "weight",     default: 1.0, null: false
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
      t.boolean  "team_subs"
    end
    
    create_table "courses", force: :cascade do |t|
      t.string   "name",                            null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "late_options", default: "10,1,0"
      t.text     "footer"
      t.integer  "term_id",                         null: false
      t.integer  "sub_max_size", default: 5,        null: false
      t.boolean  "public",       default: false,    null: false
    end
    
    create_table "delayed_jobs", force: :cascade do |t|
      t.integer  "priority",   default: 0, null: false
      t.integer  "attempts",   default: 0, null: false
      t.text     "handler",                null: false
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.string   "queue"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
    
    create_table "reg_requests", force: :cascade do |t|
      t.integer  "course_id",  null: false
      t.text     "notes"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id",    null: false
    end
    
    create_table "registrations", force: :cascade do |t|
      t.integer  "course_id",                     null: false
      t.integer  "user_id",                       null: false
      t.boolean  "teacher",       default: false, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "show_in_lists", default: true,  null: false
      t.string   "tags",          default: ""
    end
    
    add_index "registrations", ["course_id"], name: "index_registrations_on_course_id", using: :btree
    add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree
    
    create_table "submissions", force: :cascade do |t|
      t.integer  "assignment_id",                       null: false
      t.integer  "user_id",                             null: false
      t.string   "secret_dir"
      t.string   "file_name"
      t.float    "auto_score"
      t.text     "student_notes"
      t.float    "teacher_score"
      t.text     "teacher_notes"
      t.integer  "grading_uid"
      t.text     "grading_output"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "ignore_late_penalty", default: false
      t.integer  "upload_id"
      t.integer  "upload_size",         default: 0,     null: false
      t.integer  "team_id"
      t.integer  "comments_upload_id"
    end
    
    add_index "submissions", ["assignment_id"], name: "index_submissions_on_assignment_id", using: :btree
    add_index "submissions", ["grading_uid"], name: "index_submissions_on_grading_uid", unique: true, using: :btree
    add_index "submissions", ["user_id", "assignment_id"], name: "index_submissions_on_user_id_and_assignment_id", using: :btree
    add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree
    
    create_table "team_sets", force: :cascade do |t|
      t.string   "name",       null: false
      t.integer  "course_id",  null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    
    create_table "team_users", force: :cascade do |t|
      t.integer  "team_id",     null: false
      t.integer  "user_id",     null: false
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
      t.integer  "team_set_id", null: false
    end
    
    create_table "teams", force: :cascade do |t|
      t.integer  "course_id",   null: false
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
      t.integer  "team_set_id", null: false
    end
    
    create_table "terms", force: :cascade do |t|
      t.string   "name",                       null: false
      t.boolean  "archived",   default: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "uploads", force: :cascade do |t|
      t.integer  "user_id",    null: false
      t.string   "file_name",  null: false
      t.string   "secret_key", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "uploads", ["secret_key"], name: "index_uploads_on_secret_key", unique: true, using: :btree
    
    create_table "users", force: :cascade do |t|
      t.string   "name",                       null: false
      t.string   "email",                      null: false
      t.string   "auth_key",                   null: false
      t.boolean  "site_admin", default: false, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
