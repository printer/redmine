set :runner, nil
set :scm, "git"
set :keep_releases, 3

set :application, "redmine"
set :deploy_to, "/var/www/projects/#{application}"
set :user, "deployer"

set :use_sudo, false

set :repository,  "git://github.com/lovchy/redmine.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

server "odin.deviantech.ru", :app, :web
server "odin.deviantech.ru", :db, :primary => true

after 'deploy', 'deploy:cleanup'

namespace :deploy do
  [ :start, :restart ].each do |t|
    desc "#{t.to_s.capitalize} the Passenger"
    task t do
      run "sudo service nginx reload"
      run "touch #{current_path}/tmp/restart.txt"
    end
  end

  task :stop do
  end
end
