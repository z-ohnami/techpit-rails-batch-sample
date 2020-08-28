# 簡易手順書 5章

# バッチ処理をトランザクションに対応させる

## 概要
- コーディング
- 動作確認

## コーディング

```
bin/rails g migration CreateMonthlyRanks
bin/rails g migration CreateWeeklyRanks
bin/rails g migration CreateDailyRanks
```

## 動作確認

```
bin/rails db:migrate
bin/rails log:clear
bin/rails ranks:chapter5:update
```

### API利用追加後
```
bin/rails s
bin/rails log:clear
bin/rails ranks:chapter5:update
```
