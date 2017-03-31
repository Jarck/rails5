worker_processes 2

working_directory $APP_ROOT

listen "/tmp/unicorn.rails5_mina.sock"
timeout 30

pid "tmp/unicorn.rails5_mina.pid"

stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"
