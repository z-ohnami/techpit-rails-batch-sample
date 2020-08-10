# 簡易手順書 2章

# はじめてのバッチ処理を作る

## 概要
- mysqlなどgemの追加
- migration fileの作成、実行
- modelとテストデータの作成
- コーディング

## mysqlなどgemの追加
```
bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib"
bundle install
```

## migration fileの作成、実行
```
bin/rails g migration CreateUsers
bin/rails g migration CreateUserScores
bin/rails g migration CreateRanks
bin/rails db:migrate
```

## modelとテストデータの作成
```
bin/rails db:seed
```

## コーディング
