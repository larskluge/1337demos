namespace :deploy do
  desc "Restart the app"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Start the app"
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Stop the app"
  task :stop, :roles => :app do
  end
end

