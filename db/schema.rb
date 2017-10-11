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

ActiveRecord::Schema.define(version: 20171011114908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "central_reserve_in_sub_units", default: 0,    null: false
    t.boolean  "crypto_currency",              default: true, null: false
    t.integer  "subdivision",                  default: 8,    null: false
    t.index ["code"], name: "index_coins_on_code", unique: true, using: :btree
  end

  create_table "holdings", force: :cascade do |t|
    t.integer  "member_plan_id"
    t.integer  "coin_id",                                                   null: false
    t.decimal  "initial_btc_rate", precision: 10, scale: 8, default: "0.0", null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.boolean  "deposit",                                   default: false, null: false
    t.boolean  "withdrawal",                                default: false, null: false
    t.integer  "portfolio_id",                                              null: false
    t.integer  "quantity",                                                  null: false
    t.index ["coin_id", "portfolio_id"], name: "index_holdings_on_coin_id_and_portfolio_id", unique: true, using: :btree
    t.index ["member_plan_id"], name: "index_holdings_on_member_plan_id", using: :btree
    t.index ["portfolio_id"], name: "index_holdings_on_portfolio_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.string   "username"
    t.index ["email"], name: "index_members_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_members_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_members_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_members_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_members_on_username", unique: true, using: :btree
  end

  create_table "portfolios", force: :cascade do |t|
    t.integer  "member_id",         null: false
    t.integer  "next_portfolio_id"
    t.datetime "next_portfolio_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["member_id"], name: "index_portfolios_on_member_id", unique: true, where: "(next_portfolio_at IS NULL)", using: :btree
    t.index ["next_portfolio_id"], name: "index_portfolios_on_next_portfolio_id", unique: true, using: :btree
  end

  add_foreign_key "holdings", "coins", name: "holdings_coin_id_fk"
  add_foreign_key "holdings", "portfolios"
  add_foreign_key "portfolios", "members"
  add_foreign_key "portfolios", "portfolios", column: "next_portfolio_id"
end
