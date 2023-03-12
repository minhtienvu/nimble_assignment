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

ActiveRecord::Schema[7.0].define(version: 2023_03_09_063836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "file_uploads", force: :cascade do |t|
    t.integer "user_id"
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_file_uploads_on_user_id"
  end

  create_table "statistics", force: :cascade do |t|
    t.integer "file_upload_id"
    t.string "keyword"
    t.integer "total_ad_words"
    t.integer "total_links"
    t.string "total_search_results"
    t.text "html_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_upload_id"], name: "index_statistics_on_file_upload_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
