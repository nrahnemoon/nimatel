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

ActiveRecord::Schema.define(:version => 20130620011204) do

  create_table "cards", :force => true do |t|
    t.string   "pin"
    t.decimal  "balance",    :precision => 8, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "user_id"
  end

  create_table "contact_emails", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "pin"
    t.integer  "purpose"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "sound_file"
    t.string   "image_file"
    t.string   "alpha2"
    t.string   "alpha3"
    t.decimal  "landline_rate"
    t.decimal  "mobile_rate"
    t.decimal  "satellite_rate"
  end

  create_table "payment_profiles", :force => true do |t|
    t.integer  "brand"
    t.string   "last_four"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "bin"
    t.integer  "cim_payment_profile_id"
    t.string   "card_code"
  end

  create_table "phone_numbers", :force => true do |t|
    t.string   "number"
    t.boolean  "remember"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
    t.string   "caller_id_name"
  end

  create_table "rates", :force => true do |t|
    t.integer  "country_id"
    t.integer  "category"
    t.decimal  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "prefix"
    t.integer  "category"
    t.string   "registrar"
  end

  create_table "renewal_plans", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "auto_renew"
    t.decimal  "increment"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.decimal  "min_balance", :precision => 8, :scale => 2
  end

  create_table "retailers", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "gender"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "contact"
    t.string   "contact_title"
    t.string   "website"
    t.integer  "num_employees"
    t.string   "sales"
    t.string   "industry"
    t.string   "sic"
    t.string   "sic_description"
    t.string   "email"
    t.boolean  "has_calling_card"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.integer  "item_id"
    t.integer  "cim_profile_id"
    t.integer  "payment_profile_id"
    t.boolean  "completed"
    t.boolean  "voided"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "phone_number_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "cim_profile_id"
    t.integer  "default_payment_profile_id"
  end

  create_table "wholesaler_rates", :force => true do |t|
    t.string   "description"
    t.decimal  "rate",              :precision => 12, :scale => 8
    t.decimal  "billing_increment"
    t.decimal  "min_charge"
    t.integer  "wholesaler_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "prefix"
    t.integer  "category"
    t.integer  "country_id"
    t.integer  "version"
  end

  create_table "wholesalers", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "username"
    t.string   "password"
    t.string   "auth_id"
    t.string   "auth_secret"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
