# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081213133206) do

  create_table "accounts", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "customer_id"
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true

  create_table "admins", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "admins", ["login"], :name => "index_admins_on_login", :unique => true

  create_table "criteria", :force => true do |t|
    t.integer  "profile_id"
    t.string   "field"
    t.string   "condition"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "company"
    t.text     "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.string   "phone_number"
    t.string   "duns"
    t.string   "siret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.text     "description"
    t.date     "start_at"
    t.date     "stop_at"
    t.string   "frequency_unit"
    t.integer  "frequency"
    t.text     "email_title"
    t.text     "email_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subscribers", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "identifier"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birth"
    t.integer  "age"
    t.text     "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["customer_id", "email"], :name => "index_subscribers_on_customer_id_and_email", :unique => true
  add_index "subscribers", ["customer_id", "identifier"], :name => "index_subscribers_on_customer_id_and_identifier", :unique => true

end
