# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 最初は各データをリセット
# user_scoresはusersとcascadeの外部キーでつながっているため、usersを消した時点で一緒に消える
Rank.delete_all
MonthlyRank.delete_all
WeeklyRank.delete_all
DailyRank.delete_all
User.delete_all

# 第2章で使用。1件ずつデータを格納していくやり方
# # テストデータ ユーザー情報
# user1 = User.create(id: 1, name: 'ゲーム太郎')
# user2 = User.create(id: 2, name: 'ゲームガイ')
# user3 = User.create(id: 3, name: 'ゲーム好き')
# user4 = User.create(id: 4, name: 'ゲーム大臣')
# user5 = User.create(id: 5, name: 'ゲーム将軍')
#
# # テストデータ ユーザーごとの得点
# UserScore.create(user_id: user1.id, score: 3, received_at: Time.current)
# UserScore.create(user_id: user1.id, score: 4, received_at: Time.current)
# UserScore.create(user_id: user1.id, score: 1, received_at: Time.current)
#
# UserScore.create(user_id: user2.id, score: 2, received_at: Time.current)
# UserScore.create(user_id: user2.id, score: 2, received_at: Time.current)
# UserScore.create(user_id: user2.id, score: 4, received_at: Time.current)
#
# UserScore.create(user_id: user3.id, score: 1, received_at: Time.current)
# UserScore.create(user_id: user3.id, score: 1, received_at: Time.current)
# UserScore.create(user_id: user3.id, score: 1, received_at: Time.current)
#
# UserScore.create(user_id: user4.id, score: 0, received_at: Time.current)
# UserScore.create(user_id: user4.id, score: 1, received_at: Time.current)
# UserScore.create(user_id: user4.id, score: 0, received_at: Time.current)
#
# UserScore.create(user_id: user5.id, score: 3, received_at: Time.current)
# UserScore.create(user_id: user5.id, score: 3, received_at: Time.current)
# UserScore.create(user_id: user5.id, score: 3, received_at: Time.current)

# # 第3章からはこちら
# USER_AMOUNT = 1_000
#
# 1.upto(USER_AMOUNT) do |i|
#   user = User.create(id: i, name: "ゲーム太郎#{i}")
#   # テストデータ ユーザーごとの得点
#   1.upto(rand(10)) do
#     UserScore.create(user_id: user.id, score: rand(1..100), received_at: Time.current)
#   end
# end

# 第5章からはこちら
# received_at のパターンを広げるように修正
USER_AMOUNT = 1_000

1.upto(USER_AMOUNT) do |i|
  user = User.create(id: i, name: "#{i}人目のゲームユーザー")
  # テストデータ ユーザーごとの得点
  1.upto(rand(30)) do
    UserScore.create(user_id: user.id, score: rand(1..100), received_at: Time.current.ago(rand(0..60).days))
  end
end
