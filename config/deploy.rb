require 'capistrano_colors'
load "lib/recipes/servers/passenger.rb"


set :application, '1337demos'


# ssh
set :user, 'lars'
set :repository,  "ssh://#{user}@1337demos.com/home/lars/git/1337demos.git"
ssh_options[:forward_agent] = true


# git
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true # to support older git versions on server


# remote server
set :deploy_to, "/var/www/1337demos.com/#{application}"
set :deploy_via, :remote_cache    # default checkout
set :rails_env, (ENV['RAILS_ENV'] || 'production')
set :use_sudo, false
set :keep_releases, 3
set :rake, '/var/lib/gems/1.8/bin/rake'

role :app, '1337demos.com'
role :web, '1337demos.com'
role :db,  '1337demos.com', :primary => true



# symlink shared static files to new release
task :after_update_code, :roles => :app do
  run "sudo chown www-1337demos #{release_path}/config/environment.rb"



  static_dirs = %w(data/maps/images public/demofiles public/videos public/images/maps)
  static_path = "#{deploy_to}/shared/static"

  static_dirs.each do |dir|
    run "ln -nfs #{static_path}/#{dir} #{release_path}/#{dir}"
  end
end
