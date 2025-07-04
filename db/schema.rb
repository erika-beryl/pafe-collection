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

ActiveRecord::Schema[7.1].define(version: 2025_06_21_100959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_bookmarks_on_review_id"
    t.index ["user_id", "review_id"], name: "index_bookmarks_on_user_id_and_review_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "business_time"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_businesses_on_shop_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "trait"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "opentimes", force: :cascade do |t|
    t.text "business_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parfaits", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.string "name", null: false
    t.integer "price", null: false
    t.text "body"
    t.boolean "is_limited", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_parfaits_on_shop_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "method_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.bigint "parfait_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parfait_id"], name: "index_reviews_on_parfait_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shop_features", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_shop_features_on_feature_id"
    t.index ["shop_id"], name: "index_shop_features_on_shop_id"
  end

  create_table "shop_opentimes", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "opentime_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opentime_id"], name: "index_shop_opentimes_on_opentime_id"
    t.index ["shop_id"], name: "index_shop_opentimes_on_shop_id"
  end

  create_table "shop_payments", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_shop_payments_on_payment_id"
    t.index ["shop_id"], name: "index_shop_payments_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.string "postal_code", null: false
    t.integer "prefecture_code", null: false
    t.string "city", null: false
    t.string "street", null: false
    t.string "other_address"
    t.string "full_address", null: false
    t.string "tel", null: false
    t.boolean "reservation", default: false, null: false
    t.boolean "parking", default: false, null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_shops_on_name", unique: true
    t.index ["postal_code"], name: "index_shops_on_postal_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "profile"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "reviews"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "businesses", "shops"
  add_foreign_key "parfaits", "shops"
  add_foreign_key "reviews", "parfaits"
  add_foreign_key "reviews", "users"
  add_foreign_key "shop_features", "features"
  add_foreign_key "shop_features", "shops"
  add_foreign_key "shop_opentimes", "opentimes"
  add_foreign_key "shop_opentimes", "shops"
  add_foreign_key "shop_payments", "payments"
  add_foreign_key "shop_payments", "shops"
end
