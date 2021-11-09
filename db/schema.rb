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

ActiveRecord::Schema.define(version: 2021_11_09_152316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instances", force: :cascade do |t|
    t.string "name"
    t.integer "machine_id"
    t.integer "cpu"
    t.integer "memory"
    t.integer "disk_space"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string "ip_addr"
    t.integer "instance_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "machines", force: :cascade do |t|
    t.string "name"
    t.string "model"
    t.integer "cpu"
    t.integer "memory"
    t.integer "disk_space"
    t.string "ip_addr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
