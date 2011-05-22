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

ActiveRecord::Schema.define(:version => 20110522143720) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",            :limit => 32
    t.string   "mail"
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id"], :name => "commentable_id"
  add_index "comments", ["commentable_type"], :name => "commentable_type"
  add_index "comments", ["created_at"], :name => "created_at"

  create_table "demofiles", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sha1",              :limit => 40
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "demofiles", ["sha1"], :name => "index_demofiles_on_sha1"

  create_table "demos", :force => true do |t|
    t.integer  "version"
    t.string   "gamemode"
    t.string   "title"
    t.integer  "time"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "demofile_id"
    t.boolean  "data_correct"
    t.string   "status",                     :default => "uploaded"
    t.integer  "position"
    t.string   "game",         :limit => 20
  end

  add_index "demos", ["game"], :name => "index_demos_on_game"
  add_index "demos", ["map_id"], :name => "map_id"

  create_table "demos_players", :force => true do |t|
    t.integer "demo_id"
    t.integer "player_id"
    t.string  "label"
  end

  add_index "demos_players", ["demo_id"], :name => "demo_id"

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating_count"
    t.decimal  "rating_total", :precision => 10, :scale => 0
    t.decimal  "rating_avg",   :precision => 10, :scale => 2
  end

  create_table "nicknames", :force => true do |t|
    t.string   "nickname"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "main_nickname_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id",                                                               :null => false
    t.string   "rateable_type",                                                             :null => false
    t.string   "key"
    t.integer  "count",                                                      :default => 0, :null => false
    t.integer  "total",                                                      :default => 0, :null => false
    t.decimal  "average",                     :precision => 10, :scale => 2
    t.string   "last_ip",       :limit => 15
    t.datetime "updated_at",                                                                :null => false
    t.datetime "created_at",                                                                :null => false
  end

  add_index "ratings", ["rateable_id"], :name => "rateable_id_idx"
  add_index "ratings", ["rateable_type"], :name => "rateable_type_idx"

  create_table "stuffs", :force => true do |t|
    t.integer  "size"
    t.string   "filename"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sha1",                    :limit => 40
    t.string   "stuff_file_file_name"
    t.string   "stuff_file_content_type"
    t.integer  "stuff_file_file_size"
    t.datetime "stuff_file_updated_at"
  end

  add_index "stuffs", ["sha1"], :name => "index_stuffs_on_sha1"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.string   "passphrase"
    t.boolean  "approved",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name", "passphrase"], :name => "index_users_on_name_and_passphrase", :unique => true

end
