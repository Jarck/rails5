# worker_processes 2

# working_directory $APP_ROOT

# listen "/tmp/unicorn.rails5_mina.sock"
# timeout 30

# pid "tmp/unicorn.rails5_mina.pid"

# stderr_path "log/unicorn.log"
# stdout_path "log/unicorn.log"

############# for mina unicorn 自动部署  ###################
app_path = File.expand_path( File.join(File.dirname(__FILE__), '..', '..'))

worker_processes   1
preload_app        true
timeout            180
listen             '#{app_path}/tmp/sockets/unicorn.sock', :backlog => 64
pid                "#{app_path}/tmp/pids/unicorn.pid"
working_directory  app_path
user               'jarck', 'apps'
stderr_path        "log/unicorn.log"
stdout_path        "log/unicorn.log"

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end