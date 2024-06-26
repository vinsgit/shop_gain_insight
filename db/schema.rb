# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_20_051557) do
  create_table "aws_orders", force: :cascade do |t|
    t.string "order_ref"
    t.string "merchant_order_ref"
    t.string "desc"
    t.decimal "amt", default: "0.0"
    t.integer "sku_id"
    t.string "promotion_ref"
    t.decimal "amend_amt", default: "0.0"
    t.decimal "manual_amend_amt", default: "0.0"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
    t.date "posted_at"
    t.string "txn_type"
    t.string "amt_type"
    t.string "settle_id"
    t.index ["posted_at"], name: "index_aws_orders_on_posted_at"
  end

  create_table "delivery_records", force: :cascade do |t|
    t.date "deliver_at"
    t.integer "sku_id"
    t.integer "sent_count", default: 0
    t.integer "arrived_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "shop_id"
    t.index ["deliver_at"], name: "index_delivery_records_on_deliver_at"
  end

  create_table "equity_allocation_records", force: :cascade do |t|
    t.integer "investor_id"
    t.decimal "ratio"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fbm_delivery_records", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "sku_id"
    t.date "purchased_at"
    t.decimal "amt"
    t.string "note"
    t.string "purchase_note"
    t.string "delivery_method"
    t.string "delivery_status"
    t.string "order_note"
    t.string "aws_order_ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
  end

  create_table "item_links", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
  end

  create_table "item_links_skus", id: false, force: :cascade do |t|
    t.integer "sku_id", null: false
    t.integer "item_link_id", null: false
    t.index ["item_link_id", "sku_id"], name: "index_item_links_skus_on_item_link_id_and_sku_id"
    t.index ["sku_id", "item_link_id"], name: "index_item_links_skus_on_sku_id_and_item_link_id"
  end

  create_table "procurement_investors", force: :cascade do |t|
    t.integer "procurement_id"
    t.integer "investor_id"
    t.decimal "ratio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "procurements", force: :cascade do |t|
    t.integer "sku_id"
    t.integer "qty"
    t.decimal "unit_price", precision: 8, scale: 2
    t.decimal "total_price", precision: 8, scale: 2
    t.integer "received_qty"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "purchased_at"
    t.decimal "delivery_fee", default: "0.0"
    t.integer "item_link_id"
    t.integer "shop_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.datetime "transaction_at"
    t.string "aws_order_ref"
    t.string "order_ref"
    t.decimal "total_fee", default: "0.0"
    t.integer "channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skus", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.decimal "price", default: "0.0"
    t.integer "shop_id"
    t.decimal "ads_cost", default: "0.0"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
