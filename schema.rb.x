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

ActiveRecord::Schema.define(:version => 3) do

  create_table "accounts", :force => true do |t|
    t.integer  "balance",          :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "banked",           :limit => 11
    t.integer  "user_id",          :limit => 11, :default => 0, :null => false
    t.integer  "user_instance_id", :limit => 11
  end

  add_index "accounts", ["user_id"], :name => "user_id"

  create_table "deeds", :force => true do |t|
    t.integer  "property_type_id", :limit => 11
    t.integer  "user_id",          :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "square_id",        :limit => 11
    t.integer  "levels",           :limit => 11
    t.integer  "health",           :limit => 11, :default => 14, :null => false
    t.string   "name",             :limit => 50
    t.integer  "landed_on",        :limit => 11, :default => 0
    t.integer  "position",         :limit => 11
    t.integer  "instance_id",      :limit => 11
  end

  add_index "deeds", ["property_type_id"], :name => "property_type_id"
  add_index "deeds", ["square_id"], :name => "square_id"
  add_index "deeds", ["user_id"], :name => "user_id"

  create_table "event_types", :force => true do |t|
    t.string   "event",       :limit => 50
    t.string   "description", :limit => 50
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id",          :limit => 11
    t.integer  "event_type_id",    :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "instance_id",      :limit => 11
    t.integer  "user_instance_id", :limit => 11
  end

  add_index "events", ["user_id"], :name => "user_id"

  create_table "god_messages", :force => true do |t|
    t.text     "message"
    t.integer  "instance_id", :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "instance_users", :id => false, :force => true do |t|
    t.integer  "user_id",     :limit => 11
    t.integer  "instance_id", :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "instances", :force => true do |t|
    t.string   "name",        :limit => 100
    t.integer  "user_id",     :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.text     "description"
  end

  create_table "items", :force => true do |t|
    t.string   "description"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",     :limit => 11, :default => 0, :null => false
    t.integer  "square_id",   :limit => 11
    t.text     "message"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "instance_id", :limit => 11
  end

  create_table "payments", :force => true do |t|
    t.integer  "amount",     :limit => 11, :default => 0, :null => false
    t.integer  "user_id",    :limit => 11
    t.integer  "event_id",   :limit => 11
    t.integer  "deed_id",    :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "property_types", :force => true do |t|
    t.string   "title",          :limit => 50
    t.string   "description"
    t.integer  "base_price",     :limit => 11, :default => 0, :null => false
    t.integer  "min_level",      :limit => 11, :default => 0, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "base_rent",      :limit => 11
    t.integer  "max_levels",     :limit => 11
    t.integer  "level_cost",     :limit => 11
    t.integer  "level_modifier", :limit => 11
    t.integer  "position",       :limit => 11
  end

  create_table "scores", :force => true do |t|
    t.integer  "user_id",     :limit => 11, :default => 0, :null => false
    t.integer  "cash",        :limit => 11
    t.integer  "real_estate", :limit => 11
    t.integer  "buildings",   :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "instance_id", :limit => 11
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "settings", :force => true do |t|
    t.string   "variable",    :limit => 100
    t.text     "value"
    t.integer  "instance_id", :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "square_types", :force => true do |t|
    t.string   "description", :limit => 100
    t.boolean  "for_sale",                   :default => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "squares", :force => true do |t|
    t.integer  "square_type_id", :limit => 11
    t.integer  "position",       :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "deeds_count",    :limit => 11
    t.integer  "locked_by_id",   :limit => 11
    t.datetime "locked_at"
    t.integer  "messages_count", :limit => 11
    t.integer  "instance_id",    :limit => 11
  end

  add_index "squares", ["position"], :name => "position"

  create_table "user_instances", :force => true do |t|
    t.integer  "user_id",     :limit => 11
    t.integer  "instance_id", :limit => 11
    t.integer  "square_id",   :limit => 11
    t.integer  "active",      :limit => 11
    t.datetime "locked_at"
    t.integer  "deeds_count", :limit => 11
  end

  create_table "user_items", :force => true do |t|
    t.integer  "user_id",          :limit => 11
    t.string   "item_id",          :limit => 50
    t.integer  "uses_left",        :limit => 11
    t.integer  "active",           :limit => 2,  :default => 0, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "user_instance_id", :limit => 11
    t.integer  "apply_mode",       :limit => 11
  end

  add_index "user_items", ["id"], :name => "id"

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 80, :default => "", :null => false
    t.string   "salted_password", :limit => 40, :default => "", :null => false
    t.string   "email",           :limit => 60, :default => "", :null => false
    t.string   "name",            :limit => 50
    t.integer  "square_id",       :limit => 11, :default => 1,  :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "test",            :limit => 50
    t.integer  "turns",           :limit => 11, :default => 20, :null => false
    t.string   "firstname",       :limit => 40
    t.string   "lastname",        :limit => 40
    t.string   "salt",            :limit => 40
    t.integer  "verified",        :limit => 11, :default => 0
    t.string   "role",            :limit => 40
    t.string   "security_token",  :limit => 40
    t.datetime "token_expiry"
    t.datetime "logged_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deleted",         :limit => 11, :default => 0
    t.datetime "delete_after"
    t.integer  "instance_id",     :limit => 11
  end

  create_table "waiters", :force => true do |t|
    t.string   "email",      :limit => 200
    t.datetime "created_on"
  end

end
