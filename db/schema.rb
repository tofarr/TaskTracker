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

ActiveRecord::Schema.define(version: 2018_11_14_220650) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "attachments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id", null: false
    t.integer "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_attachments_on_task_id"
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_comments_on_task_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "edit_user_tags", id: false, force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_tag_id"
    t.index ["task_id", "user_tag_id"], name: "index_edit_user_tags_on_task_id_and_user_tag_id", unique: true
  end

  create_table "task_status_joins", id: false, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.index ["parent_id", "child_id"], name: "index_task_status_joins_on_parent_id_and_child_id", unique: true
  end

  create_table "task_statuses", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.boolean "requires_action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_apply", default: false, null: false
    t.string "color", limit: 8, default: "#209cee", null: false
  end

  create_table "task_tag_mutexes", force: :cascade do |t|
    t.integer "task_tag_id"
    t.integer "mutex_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mutex_id"], name: "index_task_tag_mutexes_on_mutex_id"
    t.index ["task_tag_id", "mutex_id"], name: "index_task_tag_mutexes_on_task_tag_id_and_mutex_id", unique: true
    t.index ["task_tag_id"], name: "index_task_tag_mutexes_on_task_tag_id"
  end

  create_table "task_tags", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "only_admin_can_apply", default: false, null: false
    t.boolean "default_apply", default: false, null: false
    t.string "color", limit: 8, default: "#209cee", null: false
  end

  create_table "task_tags_tasks", id: false, force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "task_tag_id", null: false
    t.index ["task_id", "task_tag_id"], name: "index_task_tags_tasks_on_task_id_and_task_tag_id"
    t.index ["task_tag_id", "task_id"], name: "index_task_tags_tasks_on_task_tag_id_and_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "parent_id"
    t.integer "assigned_user_id"
    t.integer "created_user_id"
    t.integer "status_id"
    t.float "priority"
    t.datetime "due_date"
    t.integer "estimate"
    t.integer "calculated_estimate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_tag_mutexes", force: :cascade do |t|
    t.integer "user_tag_id"
    t.integer "mutex_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mutex_id"], name: "index_user_tag_mutexes_on_mutex_id"
    t.index ["user_tag_id", "mutex_id"], name: "index_user_tag_mutexes_on_user_tag_id_and_mutex_id", unique: true
    t.index ["user_tag_id"], name: "index_user_tag_mutexes_on_user_tag_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "only_admin_can_apply", default: false, null: false
    t.boolean "default_apply", default: false, null: false
    t.string "color", limit: 8, default: "#209cee", null: false
  end

  create_table "user_tags_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "user_tag_id", null: false
    t.index ["user_id", "user_tag_id"], name: "index_user_tags_users_on_user_id_and_user_tag_id"
    t.index ["user_tag_id", "user_id"], name: "index_user_tags_users_on_user_tag_id_and_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "username", null: false
    t.string "password_digest"
    t.string "verification_code"
    t.boolean "admin", default: false, null: false
    t.boolean "suspended", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "view_user_tags", id: false, force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_tag_id"
    t.index ["task_id", "user_tag_id"], name: "index_view_user_tags_on_task_id_and_user_tag_id", unique: true
  end

end
