# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_26_005541) do

  create_table "daily_ranks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "前日の累計スコアに基づくランキング情報", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.integer "rank", default: 0, null: false, comment: "ユーザーの順位"
    t.integer "score", default: 0, null: false, comment: "このランクに至ったスコアの累計"
    t.datetime "created_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.index ["rank"], name: "index_daily_ranks_on_rank"
    t.index ["user_id"], name: "index_daily_ranks_on_user_id"
  end

  create_table "monthly_ranks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "当月の累計スコアに基づくランキング情報", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.integer "rank", default: 0, null: false, comment: "ユーザーの順位"
    t.integer "score", default: 0, null: false, comment: "このランクに至ったスコアの累計"
    t.string "score_title", default: "", null: false, comment: "スコアに基づく称号"
    t.datetime "created_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.index ["rank"], name: "index_monthly_ranks_on_rank"
    t.index ["user_id"], name: "index_monthly_ranks_on_user_id"
  end

  create_table "ranks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "ゲーム内のランキング情報", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.integer "rank", default: 0, null: false, comment: "ユーザーの順位"
    t.integer "score", default: 0, null: false, comment: "このランクに至ったスコア"
    t.datetime "created_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.index ["rank"], name: "index_ranks_on_rank"
    t.index ["score"], name: "index_ranks_on_score"
    t.index ["user_id"], name: "index_ranks_on_user_id"
  end

  create_table "user_scores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "ユーザーがゲーム内で獲得した点数", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.integer "score", default: 0, null: false, comment: "ユーザーが獲得した点数"
    t.datetime "received_at", null: false, comment: "点数を獲得した日時"
    t.datetime "created_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.index ["received_at"], name: "index_user_scores_on_received_at"
    t.index ["user_id"], name: "index_user_scores_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "ゲームのユーザー情報を管理するテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "ユーザーの名前"
    t.datetime "created_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
  end

  create_table "weekly_ranks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "その週の累計スコアに基づくランキング情報", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.integer "rank", default: 0, null: false, comment: "ユーザーの順位"
    t.integer "score", default: 0, null: false, comment: "このランクに至ったスコアの累計"
    t.datetime "created_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "current_timestamp(6)" }, null: false
    t.index ["rank"], name: "index_weekly_ranks_on_rank"
    t.index ["user_id"], name: "index_weekly_ranks_on_user_id"
  end

  add_foreign_key "daily_ranks", "users"
  add_foreign_key "monthly_ranks", "users"
  add_foreign_key "ranks", "users"
  add_foreign_key "user_scores", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "weekly_ranks", "users"
end
