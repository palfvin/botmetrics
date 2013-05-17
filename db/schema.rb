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

ActiveRecord::Schema.define(:version => 20130515184748) do

  create_table "charts", :force => true do |t|
    t.string   "data_source"
    t.text     "options"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "javascript"
    t.integer  "user_id"
    t.string   "name"
  end

  create_table "dashboard_elements", :force => true do |t|
    t.integer  "chart_id"
    t.integer  "dashboard_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "top"
    t.integer  "left"
  end

  create_table "dashboards", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "provider"
    t.string   "uid"
  end

end
