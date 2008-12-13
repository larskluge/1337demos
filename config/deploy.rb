set :application, "1337demos"
set :repository,  "svn+ssh://lars@1337demos.com/home/lars/.svnrepo/1337demos/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/var/www/1337demos.com/1337demos_production"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "1337demos.com"
role :web, "1337demos.com"
role :db,  "1337demos.com", :primary => true

set :user, "lars"
set :deploy_via, :checkout    # default checkout

