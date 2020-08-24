# 簡易手順書 3章

# リファクタリングをしながらテストコードを書こう

## 概要
- リファクタリングの実施
- rspecを実行できるようにする
- テストコードの作成
- さらにリファクタリング

## rspecを実行できるようにする
```
bundle install
bin/rails g rspec:install
bin/rails db:migrate RAILS_ENV=test
bundle exec rspec
```

## さらにリファクタリング
```
bin/rails c
User.all.select { |user| user.total_score.nonzero? }.sort_by { |user| [user.total_score * -1, user.created_at] }
User.includes(:user_scores).find_each.select { |user| user.total_score.nonzero? }.sort_by { |user| [user.total_score * -1, user.created_at] }

bin/rails ranks:chapter3:update
bin/rails ranks:chapter3_refactoring:update

RAILS_ENV=test bin/rails db:migrate
```
