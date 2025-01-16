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

ActiveRecord::Schema[7.1].define(version: 2025_01_05_132313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "features", force: :cascade do |t|
    t.integer "trait"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "opentimes", force: :cascade do |t|
    t.text "business_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "method_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "shop_features", "features"
  add_foreign_key "shop_features", "shops"
  add_foreign_key "shop_opentimes", "opentimes"
  add_foreign_key "shop_opentimes", "shops"
  add_foreign_key "shop_payments", "payments"
  add_foreign_key "shop_payments", "shops"
end
