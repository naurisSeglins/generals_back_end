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

ActiveRecord::Schema[7.2].define(version: 2025_08_03_125527) do
  create_table "units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.decimal "position_x", default: "0.0", null: false
    t.decimal "position_y", default: "0.0", null: false
    t.index ["name"], name: "index_units_on_name"
    t.index ["position_x"], name: "index_units_on_position_x"
    t.index ["position_y"], name: "index_units_on_position_y"
  end
end
