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

ActiveRecord::Schema.define(version: 2019_04_11_125819) do

  create_table "access_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.string "token"
    t.datetime "expires_at"
    t.boolean "suspended", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read_only", default: false, null: false
    t.index ["expires_at"], name: "index_access_tokens_on_expires_at"
    t.index ["title"], name: "index_access_tokens_on_title"
    t.index ["token"], name: "index_access_tokens_on_token", unique: true
  end

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

  create_table "activity_logs", force: :cascade do |t|
    t.integer "user_id"
    t.string "username", null: false
    t.string "model_type", limit: 50, null: false
    t.integer "model_id", null: false
    t.string "action", limit: 50, null: false
    t.text "updates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_activity_logs_on_created_at"
    t.index ["model_id"], name: "index_activity_logs_on_model_id"
    t.index ["model_type"], name: "index_activity_logs_on_model_type"
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

  create_table "notifications", force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_id", null: false
    t.integer "created_by_user_id"
    t.boolean "include_in_email", default: true, null: false
    t.boolean "seen", default: false, null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_notifications_on_task_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "sprints", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "start_at", null: false
    t.datetime "finish_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finish_at"], name: "index_sprints_on_finish_at"
    t.index ["start_at"], name: "index_sprints_on_start_at"
  end

  create_table "sprints_tasks", id: false, force: :cascade do |t|
    t.integer "sprint_id", null: false
    t.integer "task_id", null: false
  end

  create_table "sprints_users", id: false, force: :cascade do |t|
    t.integer "sprint_id", null: false
    t.integer "user_id", null: false
  end

  create_table "task_links", force: :cascade do |t|
    t.integer "from_task_id", null: false
    t.integer "to_task_id", null: false
    t.string "link_type", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_task_id", "to_task_id"], name: "index_task_links_on_from_task_id_and_to_task_id", unique: true
    t.index ["from_task_id"], name: "index_task_links_on_from_task_id"
    t.index ["link_type"], name: "index_task_links_on_link_type"
    t.index ["to_task_id"], name: "index_task_links_on_to_task_id"
  end

  create_table "task_searches", force: :cascade do |t|
    t.string "query"
    t.string "title", null: false
    t.integer "user_id", null: false
    t.boolean "public", default: false, null: false
    t.string "sort_order"
    t.boolean "descending", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_searches_assigned_user_tags", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "user_tag_id", null: false
    t.index ["task_search_id", "user_tag_id"], name: "idx_task_searches_assigned_user_tags", unique: true
  end

  create_table "task_searches_assigned_users", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "user_id", null: false
    t.index ["task_search_id", "user_id"], name: "idx_task_searches_assigned_users", unique: true
  end

  create_table "task_searches_created_by_user_tags", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "user_tag_id", null: false
    t.index ["task_search_id", "user_tag_id"], name: "idx_task_searches_created_by_user_tags", unique: true
  end

  create_table "task_searches_created_by_users", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "user_id", null: false
    t.index ["task_search_id", "user_id"], name: "idx_task_searches_created_by_users", unique: true
  end

  create_table "task_searches_created_user_tags", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "user_tag_id", null: false
    t.index ["task_search_id", "user_tag_id"], name: "idx_task_searches_created_user_tags", unique: true
  end

  create_table "task_searches_created_users", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "user_id", null: false
    t.index ["task_search_id", "user_id"], name: "idx_task_searches_created_users", unique: true
  end

  create_table "task_searches_statuses", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "task_status_id", null: false
    t.index ["task_search_id", "task_status_id"], name: "idx_task_searches_statuses", unique: true
  end

  create_table "task_searches_tags", id: false, force: :cascade do |t|
    t.integer "task_search_id", null: false
    t.integer "task_tag_id", null: false
    t.index ["task_search_id", "task_tag_id"], name: "idx_task_searches_tags", unique: true
  end

  create_table "task_status_joins", id: false, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.index ["parent_id", "child_id"], name: "index_task_status_joins_on_parent_id_and_child_id", unique: true
  end

  create_table "task_statuses", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.boolean "requires_action", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_apply", default: false, null: false
    t.string "color", limit: 8, null: false
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
    t.string "color", limit: 8, null: false
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
    t.integer "created_by_user_id"
    t.integer "status_id"
    t.float "priority"
    t.datetime "due_date"
    t.integer "estimate"
    t.integer "calculated_estimate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "viewable", default: true, null: false
    t.boolean "editable", default: true, null: false
    t.boolean "commentable", default: true, null: false
    t.boolean "public_viewable", default: false, null: false
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
    t.string "color", limit: 8, null: false
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
    t.boolean "admin", default: false, null: false
    t.boolean "suspended", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", limit: 30, default: "en", null: false
    t.string "timezone", limit: 100, default: "UTC", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
