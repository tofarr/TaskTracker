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

ActiveRecord::Schema.define(version: 2018_10_28_153755) do

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
  end

  create_table "task_tags", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_tags", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "only_admin_can_apply", default: false, null: false
    t.boolean "default_apply", default: false, null: false
  end

  create_table "user_tags_mutex", id: false, force: :cascade do |t|
    t.integer "a_id"
    t.integer "b_id"
    t.index ["a_id", "b_id"], name: "index_user_tags_mutex_on_a_id_and_b_id", unique: true
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

end
