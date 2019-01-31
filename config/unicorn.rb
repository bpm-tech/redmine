# -*- coding: utf-8 -*-
# Unicorn設定ファイル
# 次のURLのサンプルをベースにしている。
# http://unicorn.bogomips.org/examples/unicorn.conf.rb

# 専用サーバーであればコアにつき1個以上を指定する。
worker_processes 2

# リクエスト待ち受け口、TCPとUNIXドメインとが指定可能。
#listen 3000
#listen "/var/lib/redmine/tmp/sockets/redmine.sock", :backlog => 32
WORK_DIR="/app"
listen "#{WORK_DIR}/tmp/sockets/unicorn.sock", :backlog => 32
# listen 8282, :tcp_nopush => true

# タイムアウト秒数
timeout 30

# 稼働中のプロセスのPIDを書いておくファイル。
#pid "/var/lib/redmine/tmp/pids/redmine.pid"
pid "#{WORK_DIR}/tmp/pids/unicorn.pid"

# デーモンで起動すると標準出力／標準エラー出力が/dev/nullになるので、
# それぞれログファイルに出力する。
# /var/logで一元管理する場合はフルパスで記載、その場合は/var/log配下にunicornディレクトリを作っておく。
# stderr_path '/var/log/unicorn/unicorn.stderr.log'
# stdout_path '/var/log/unicorn/unicorn.stdout.log'
# stderr_path 'log/unicorn.stderr.log'
# stdout_path 'log/unicorn.stdout.log'

#stderr_path $stdout
#stdout_path $stderr

# マスタープロセス起動時にアプリケーションをロードする(true時)。
# ワーカープロセス側でロードをしないのでメモリ消費、応答性良好になる。
# ただし、ソケットはfork後に開きなおす必要あり。
# HUPシグナルでアプリケーションはロードされない。
preload_app false

# unicornと同一ホスト上のクライアントとのコネクション限定で、維持されているかを
# アプリケーションを呼ぶ前にチェックする。
check_client_connection false

before_fork do |server, worker|
  # Railsでpreload_appをtrueにしているときは強く推奨
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # Railsでpreload_appをtrueにしているときは必須
  #defined?(ActiveRecord::Base) and
  #  ActiveRecord::Base.establish_connection

  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
