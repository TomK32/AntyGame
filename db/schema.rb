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

ActiveRecord::Schema.define(:version => 20090823174840) do

  create_table "actions", :force => true do |t|
    t.integer  "item_id",                             :null => false
    t.integer  "map_id"
    t.integer  "babysitter_id"
    t.string   "state",         :default => "active", :null => false
    t.integer  "latitude"
    t.integer  "longitude"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anthills", :force => true do |t|
    t.integer  "user_id",                              :null => false
    t.integer  "babysitter_id"
    t.integer  "longitude",                            :null => false
    t.integer  "latitude",                             :null => false
    t.string   "name",                                 :null => false
    t.string   "state",          :default => "active"
    t.integer  "worker_count",   :default => 0,        :null => false
    t.integer  "soldier_count",  :default => 0,        :null => false
    t.datetime "last_action_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "map_id",                               :null => false
    t.integer  "food",                                 :null => false
    t.integer  "nursing",                              :null => false
    t.integer  "building",                             :null => false
    t.integer  "food_stock",     :default => 0,        :null => false
    t.integer  "building_count", :default => 0,        :null => false
    t.integer  "max_nursing",    :default => 0,        :null => false
  end

  create_table "ants", :force => true do |t|
    t.string   "type"
    t.integer  "dna",        :limit => 8, :null => false
    t.integer  "count"
    t.integer  "longitude"
    t.integer  "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "anthill_id",              :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.integer  "ant_id"
    t.integer  "anthill_id"
    t.integer  "longitude",  :null => false
    t.integer  "latitude",   :null => false
    t.integer  "count"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
  end

  create_table "maps", :force => true do |t|
    t.string   "name",                               :null => false
    t.integer  "width",        :default => 120,      :null => false
    t.integer  "height",       :default => 80,       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_anthills", :default => 5,        :null => false
    t.string   "state",        :default => "active"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "identity_url"
    t.boolean  "subscription_active",                      :default => false
    t.string   "subscription_plan"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
