require 'bundler/capistrano'

set :application, '1337demos'


# ssh
set :user, 'lars'
set :repository,  "ssh://#{user}@1337demos.com/home/lars/git/1337demos.git"
ssh_options[:forward_agent] = true

# bundler
set :bundle_cmd, "/var/lib/gems/1.9.1/bin/bundle"

# git
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true # to support older git versions on server
set :git_enable_submodules, 1


# remote server
set :deploy_to, "/var/www/1337demos.com/#{application}"
set :deploy_via, :remote_cache    # default checkout
set :copy_exclude, ".git"
set :rails_env, (ENV['RAILS_ENV'] || 'production')
set :use_sudo, false
set :keep_releases, 3
set :rake, '/var/lib/gems/1.8/bin/rake'

role :app, '1337demos.com'
role :web, '1337demos.com'
role :db,  '1337demos.com', :primary => true



# symlink shared static files to new release
task :after_update_code, :roles => :app do
  writeable_paths = %w(config/environment.rb tmp public/javascripts public/stylesheets)
  writeable_paths.each do |path|
    run "chmod g+w #{release_path}/#{path}"
    run "sudo chown www-1337demos #{release_path}/#{path}"
  end



  static_dirs = %w(data/maps/images public/stuffs public/demofiles public/system public/videos public/images/maps)
  static_path = "#{deploy_to}/shared/static"

  static_dirs.each do |dir|
    run "ln -nfs #{static_path}/#{dir} #{release_path}/#{dir}"
  end

  # database.yml
  #
  run "rm '#{release_path}/config/database.yml'"
  run "ln -s '#{deploy_to}/shared/config/database.yml' '#{release_path}/config/database.yml'"

  # fix active_scaffold issue
  # FIXME: remove this when issue is fixed by a newer version of active_scaffold (2010-09-08)
  #
  run "chmod -R a+w #{release_path}/public/javascripts/active_scaffold/default"
end

