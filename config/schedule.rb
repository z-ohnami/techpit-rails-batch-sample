# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

rails_env = ENV['RAILS_ENV'] || 'development'
set :environment, rails_env

set :chronic_options, hours24: true

# バッチ処理を実行する環境の設定に応じて、実行コマンドのテンプレートを指定する
set :job_template, "/bin/bash -l -c ':job'"

# 環境ごとにバッチ処理の起動時間を変える場合などはRAILS_ENVを変数にして
# 設定を分岐させるとよいです

case rails_env
when 'production'
  # 毎日6時に実行する
  every 1.day, at: '6:00' do
    rake 'ranks:chapter5:update'
  end

when 'development'
  # 毎日11時に実行する
  every 1.day, at: '11:00' do
    rake 'ranks:chapter5:update'
  end
end
