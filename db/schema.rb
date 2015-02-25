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

ActiveRecord::Schema.define(:version => 20150225115709) do

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filials", :force => true do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "telephone"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_reads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oblasts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poster_id"
    t.integer  "filial_id"
  end

  add_index "prices", ["filial_id"], :name => "index_prices_on_filial_id"
  add_index "prices", ["poster_id"], :name => "index_prices_on_poster_id"

  create_table "prices_reads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "invited"
    t.datetime "key_timestamp"
    t.string   "phone_number"
    t.string   "role"
    t.boolean  "receive_messages",                        :default => true
    t.string   "position"
    t.datetime "last_active_at"
    t.integer  "filial_id"
  end

  add_index "users", ["filial_id"], :name => "index_users_on_filial_id"
  add_index "users", ["state"], :name => "index_users_on_state"

end
