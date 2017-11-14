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

ActiveRecord::Schema.define(version: 20171114100551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

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

  create_table "event_store_events", id: :serial, force: :cascade do |t|
    t.string "stream", null: false
    t.string "event_type", null: false
    t.string "event_id", null: false
    t.text "metadata"
    t.text "data", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["stream"], name: "index_event_store_events_on_stream"
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

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "recipient_id"
    t.string "notification_type"
    t.string "title"
    t.text "body"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "withdrawl_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "state", default: "pending"
    t.uuid "member_id"
    t.uuid "coin_id"
    t.integer "quantity"
    t.uuid "transaction_id"
    t.uuid "last_changed_by_id"
    t.uuid "in_progress_by_id"
    t.uuid "confirmed_by_id"
    t.uuid "completed_by_id"
    t.uuid "cancelled_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cancelled_by_id"], name: "index_withdrawl_requests_on_cancelled_by_id"
    t.index ["coin_id"], name: "index_withdrawl_requests_on_coin_id"
    t.index ["completed_by_id"], name: "index_withdrawl_requests_on_completed_by_id"
    t.index ["confirmed_by_id"], name: "index_withdrawl_requests_on_confirmed_by_id"
    t.index ["in_progress_by_id"], name: "index_withdrawl_requests_on_in_progress_by_id"
    t.index ["last_changed_by_id"], name: "index_withdrawl_requests_on_last_changed_by_id"
    t.index ["member_id"], name: "index_withdrawl_requests_on_member_id"
  end

  add_foreign_key "withdrawl_requests", "coins"
  add_foreign_key "withdrawl_requests", "members"
end
