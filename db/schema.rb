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

ActiveRecord::Schema.define(:version => 20081106223503) do

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "published",                :default => false, :null => false
    t.integer  "parent_id",  :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "controller",               :default => "",    :null => false
    t.string   "action",                   :default => "",    :null => false
    t.integer  "lft",        :limit => 10,                    :null => false
    t.integer  "rgt",        :limit => 10,                    :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.integer  "commentable_id",   :limit => 11
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",            :limit => 32
  end

  create_table "demofiles", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size",         :limit => 11
    t.integer  "parent_id",    :limit => 11
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "md5",          :limit => 32
  end

  create_table "demos", :force => true do |t|
    t.integer  "version",      :limit => 11
    t.string   "gamemode"
    t.string   "title"
    t.integer  "time",         :limit => 11
    t.integer  "map_id",       :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "demofile_id",  :limit => 11
    t.boolean  "data_correct"
    t.enum     "status",       :limit => [:uploaded, :processing, :rendered], :default => :uploaded
  end

  create_table "demos_players", :id => false, :force => true do |t|
    t.integer "demo_id",   :limit => 11
    t.integer "player_id", :limit => 11
    t.enum    "label",     :limit => [:alpha, :beta, :gamma, :delta]
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating_count", :limit => 11
    t.integer  "rating_total", :limit => 10, :precision => 10, :scale => 0
    t.decimal  "rating_avg",                 :precision => 10, :scale => 2
  end

  create_table "nicknames", :force => true do |t|
    t.string   "nickname"
    t.integer  "player_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "main_nickname_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id",   :limit => 10,                                                :null => false
    t.string   "rateable_type",                                              :default => "", :null => false
    t.string   "key"
    t.integer  "count",         :limit => 10,                                :default => 0,  :null => false
    t.integer  "total",         :limit => 10,                                :default => 0,  :null => false
    t.decimal  "average",                     :precision => 10, :scale => 2
    t.string   "last_ip",       :limit => 15
    t.datetime "updated_at",                                                                 :null => false
    t.datetime "created_at",                                                                 :null => false
  end

  create_table "shoutboxes", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.datetime "created_at"
  end

  create_table "videos", :force => true do |t|
    t.string   "uri",         :default => "",    :null => false
    t.boolean  "approved",    :default => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
