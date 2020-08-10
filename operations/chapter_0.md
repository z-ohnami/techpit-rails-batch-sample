# 簡易手順書 0章

# 環境を構築する

## 概要
- rubyとrailsをセットアップする
- dockerでDBサーバーをセットアップする
- DB内の初期設定

## rubyとrailsをセットアップする
```
echo '2.7.1' > .ruby-version
rbenv install 2.7.1
bundle init
vim Gemfile
bundle install --path=.bundle
bundle exec rails new .
bin/rails s
```

## dockerでDBサーバーをセットアップする
```
docker-compose up -d
docker ps
```

## DB内の初期設定
```
brew install mysql@5.7
export PATH="/usr/local/Cellar/mysql@5.7/5.7.24/bin:$PATH"
exec $SHELL -l
mysql -h 127.0.0.1 -u root -p < ./db/setup_for_dev.sql
```
