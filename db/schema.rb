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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130316203519) do

  create_table "lots", :force => true do |t|
    t.boolean  "active"
    t.integer  "content_ID"
    t.string   "grade"
    t.integer  "grade_num"
    t.string   "image"
    t.string   "included"
    t.integer  "inventory_ID"
    t.string   "location"
    t.string   "not_included"
    t.string   "notes"
    t.integer  "page"
    t.decimal  "price"
    t.integer  "product_id"
    t.integer  "row"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "products", :force => true do |t|
    t.boolean  "available"
    t.integer  "item_ID"
    t.string   "name"
    t.string   "static_image"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
