# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130803024614) do

  create_table "lots", force: true do |t|
    t.integer  "product_id",                                              null: false
    t.integer  "cowboom_lot_id",                                          null: false
    t.integer  "content_id",                                              null: false
    t.decimal  "price",          precision: 12, scale: 4,                 null: false
    t.string   "grade"
    t.integer  "grade_num",                               default: 10
    t.text     "included"
    t.text     "location"
    t.text     "not_included"
    t.text     "notes"
    t.boolean  "active",                                  default: false, null: false
    t.string   "image"
    t.integer  "page",                                                    null: false
    t.integer  "row",                                                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "cowboom_id",                   null: false
    t.string   "name",                         null: false
    t.boolean  "available",    default: false, null: false
    t.string   "static_image",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
