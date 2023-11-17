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

ActiveRecord::Schema[7.0].define(version: 2023_11_16_134127) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currency_packages", force: :cascade do |t|
    t.string "name", null: false
    t.integer "need_one_gacha_stones", null: false
    t.integer "price", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gachas", force: :cascade do |t|
    t.date "date", null: false
    t.integer "count"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "currency_package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_package_id"], name: "index_gachas_on_currency_package_id"
    t.index ["user_id"], name: "index_gachas_on_user_id"
  end

  create_table "user_packages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "currency_package_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_package_id"], name: "index_user_packages_on_currency_package_id"
    t.index ["user_id", "currency_package_id"], name: "index_user_packages_on_user_id_and_currency_package_id", unique: true
    t.index ["user_id"], name: "index_user_packages_on_user_id"
  end

  create_table "user_posses_stones", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "currency_package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["currency_package_id"], name: "index_user_posses_stones_on_currency_package_id"
    t.index ["user_id"], name: "index_user_posses_stones_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "gachas", "currency_packages"
  add_foreign_key "gachas", "users"
  add_foreign_key "user_packages", "currency_packages"
  add_foreign_key "user_packages", "users"
  add_foreign_key "user_posses_stones", "currency_packages"
  add_foreign_key "user_posses_stones", "users"
end
