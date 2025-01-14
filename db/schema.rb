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

ActiveRecord::Schema[7.0].define(version: 2024_09_06_025450) do
  create_table "form_histories", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.text "apply_prompt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.text "job_page_link", null: false
    t.text "gpt_prompt"
    t.text "gpt_reply"
    t.integer "status", default: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_page_link"], name: "index_jobs_on_job_page_link", unique: true
  end

  create_table "system_settings", force: :cascade do |t|
    t.string "attribute_name", null: false
    t.boolean "status", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
