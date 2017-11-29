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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171116162843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "coin_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "coin_id"
    t.uuid "transaction_id"
    t.bigint "assets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_coin_events_on_coin_id"
    t.index ["transaction_id"], name: "index_coin_events_on_transaction_id"
  end

  create_table "coins", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "crypto_currency", default: true, null: false
    t.integer "subdivision", default: 8, null: false
    t.string "slug"
    t.index ["code"], name: "index_coins_on_code", unique: true
  end

  create_table "friendly_id_slugs", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.uuid "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "member_coin_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "coin_id"
    t.uuid "member_id"
    t.uuid "transaction_id"
    t.bigint "admin_liability"
    t.bigint "liability"
    t.decimal "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_member_coin_events_on_coin_id"
    t.index ["member_id"], name: "index_member_coin_events_on_member_id"
    t.index ["transaction_id"], name: "index_member_coin_events_on_transaction_id"
  end

  create_table "members", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.uuid "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "username"
    t.string "slug"
    t.integer "second_factor_attempts_count", default: 0
    t.string "encrypted_otp_secret_key"
    t.string "encrypted_otp_secret_key_iv"
    t.string "encrypted_otp_secret_key_salt"
    t.string "direct_otp"
    t.datetime "direct_otp_sent_at"
    t.datetime "totp_timestamp"
    t.boolean "two_factor_enabled", default: false
    t.string "country_code"
    t.string "phone_number"
    t.integer "second_factor_recovery_count", default: 0
    t.text "otp_recovery_codes", array: true
    t.string "otp_delivery_method"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["encrypted_otp_secret_key"], name: "index_members_on_encrypted_otp_secret_key", unique: true
    t.index ["invitation_token"], name: "index_members_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_members_on_invitations_count"
    t.index ["invited_by_id"], name: "index_members_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_members_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
    t.index ["username"], name: "index_members_on_username", unique: true
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "source_type", null: false
    t.uuid "source_id", null: false
    t.uuid "source_coin_id", null: false
    t.string "destination_type", null: false
    t.uuid "destination_id", null: false
    t.uuid "destination_coin_id", null: false
    t.uuid "previous_transaction_id"
    t.uuid "initiated_by_id", null: false
    t.uuid "authorized_by_id"
    t.string "type", null: false
    t.bigint "source_quantity"
    t.decimal "source_rate"
    t.bigint "destination_quantity"
    t.decimal "destination_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorized_by_id"], name: "index_transactions_on_authorized_by_id"
    t.index ["destination_coin_id"], name: "index_transactions_on_destination_coin_id"
    t.index ["destination_type", "destination_id"], name: "index_transactions_on_destination_type_and_destination_id"
    t.index ["initiated_by_id"], name: "index_transactions_on_initiated_by_id"
    t.index ["previous_transaction_id"], name: "index_transactions_on_previous_transaction_id"
    t.index ["source_coin_id"], name: "index_transactions_on_source_coin_id"
    t.index ["source_type", "source_id"], name: "index_transactions_on_source_type_and_source_id"
  end

  add_foreign_key "coin_events", "coins"
  add_foreign_key "coin_events", "transactions"
  add_foreign_key "member_coin_events", "coins"
  add_foreign_key "member_coin_events", "members"
  add_foreign_key "member_coin_events", "transactions"
  add_foreign_key "transactions", "coins", column: "destination_coin_id"
  add_foreign_key "transactions", "coins", column: "source_coin_id"
  add_foreign_key "transactions", "members", column: "authorized_by_id"
  add_foreign_key "transactions", "members", column: "initiated_by_id"
  add_foreign_key "transactions", "transactions", column: "previous_transaction_id"
end
