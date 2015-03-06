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

ActiveRecord::Schema.define(:version => 20150306134352) do

  create_table "checks", :force => true do |t|
    t.string   "check_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poster_id"
    t.integer  "filial_id"
    t.boolean  "deliver",    :default => false
  end

  add_index "checks", ["filial_id"], :name => "index_checks_on_filial_id"
  add_index "checks", ["poster_id"], :name => "index_checks_on_poster_id"

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipient_id"
    t.integer  "poster_id"
    t.integer  "price_id"
  end

  add_index "comments", ["poster_id"], :name => "index_comments_on_poster_id"
  add_index "comments", ["price_id"], :name => "index_comments_on_price_id"
  add_index "comments", ["recipient_id"], :name => "index_comments_on_recipient_id"

  create_table "filials", :force => true do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "telephone"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_id"
    t.string   "morion"
    t.string   "codeg"
    t.string   "madein"
    t.string   "nds"
    t.decimal  "cena",       :precision => 12, :scale => 2, :default => 0.0
    t.date     "srok"
    t.decimal  "count",      :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "nacenka",    :precision => 12, :scale => 2, :default => 35.0
  end

  add_index "goods", ["price_id"], :name => "index_goods_on_price_id"

  create_table "logs", :force => true do |t|
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "params"
    t.string   "ht_key"
    t.string   "message"
    t.integer  "logable_id"
    t.string   "logable_type"
    t.integer  "user_id"
  end

  add_index "logs", ["logable_type", "logable_id"], :name => "index_logs_on_logable_type_and_logable_id"
  add_index "logs", ["user_id"], :name => "index_logs_on_user_id"

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
    t.integer  "price_id"
    t.integer  "user_id"
  end

  add_index "prices_reads", ["price_id"], :name => "index_prices_reads_on_price_id"
  add_index "prices_reads", ["user_id"], :name => "index_prices_reads_on_user_id"

  create_table "storages", :force => true do |t|
    t.string   "morion"
    t.string   "codeg"
    t.string   "name"
    t.string   "madein"
    t.string   "nds"
    t.decimal  "cena",          :precision => 12, :scale => 2, :default => 0.0
    t.date     "srok"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_id"
    t.integer  "filial_id"
    t.decimal  "count",         :precision => 12, :scale => 2, :default => 0.0
    t.string   "location_good"
    t.boolean  "check",                                        :default => false
    t.decimal  "good_minus",    :precision => 12, :scale => 2, :default => 0.0
    t.string   "pr_name"
  end

  add_index "storages", ["filial_id"], :name => "index_storages_on_filial_id"
  add_index "storages", ["price_id"], :name => "index_storages_on_price_id"

  create_table "uploads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.integer  "poster_id"
  end

  add_index "uploads", ["poster_id"], :name => "index_uploads_on_poster_id"
  add_index "uploads", ["uploadable_type", "uploadable_id"], :name => "index_uploads_on_uploadable_type_and_uploadable_id"

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
