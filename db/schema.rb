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

ActiveRecord::Schema[7.0].define(version: 2023_09_25_080454) do
  create_table "conversion_data", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "currency_package_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_package_id"], name: "index_conversion_data_on_currency_package_id"
    t.index ["user_id"], name: "index_conversion_data_on_user_id"
  end

  create_table "currency_packages", force: :cascade do |t|
    t.integer "price", null: false
    t.integer "quantity", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_currency_packages_on_game_id"
  end

  create_table "gachas", force: :cascade do |t|
    t.date "date", null: false
    t.integer "count"
    t.string "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gachas_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "need_one_gacha_stones", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_posses_stones", force: :cascade do |t|
    t.integer "quantity"
    t.integer "conversion_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversion_data_id"], name: "index_user_posses_stones_on_conversion_data_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "conversion_data", "currency_packages"
  add_foreign_key "conversion_data", "users"
  add_foreign_key "currency_packages", "games"
  add_foreign_key "gachas", "users"
  add_foreign_key "user_posses_stones", "conversion_data", column: "conversion_data_id"
end
