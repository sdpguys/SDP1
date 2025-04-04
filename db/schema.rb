# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_19_121625) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.string "course_instructor"
    t.string "course_grading_criteria"
    t.string "courses_your_grade"
    t.string "course_comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.text "message"
    t.integer "user_id", null: false
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "quiz_results", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "week_id", null: false
    t.integer "score"
    t.integer "total_questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_quiz_results_on_user_id"
    t.index ["week_id"], name: "index_quiz_results_on_week_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "week_id"
    t.integer "course_id"
    t.index ["course_id"], name: "index_quizzes_on_course_id"
    t.index ["week_id"], name: "index_quizzes_on_week_id"
  end

  create_table "quizzesthats", force: :cascade do |t|
    t.text "question", null: false
    t.text "options", default: "[]"
    t.string "answer", null: false
    t.integer "week_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_quizzesthats_on_course_id"
    t.index ["week_id"], name: "index_quizzesthats_on_week_id"
  end

  create_table "user_courses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_courses_on_course_id"
    t.index ["user_id"], name: "index_user_courses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "surname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeks", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_weeks_on_course_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "quiz_results", "users"
  add_foreign_key "quiz_results", "weeks"
  add_foreign_key "quizzes", "courses", on_delete: :cascade
  add_foreign_key "quizzes", "weeks", on_delete: :cascade
  add_foreign_key "quizzesthats", "courses", on_delete: :cascade
  add_foreign_key "quizzesthats", "weeks", on_delete: :cascade
  add_foreign_key "user_courses", "courses", on_delete: :cascade
  add_foreign_key "user_courses", "users"
  add_foreign_key "weeks", "courses", on_delete: :cascade
end
