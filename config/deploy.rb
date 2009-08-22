set :application, "antgame"
#set :repository,  "antga.me:/var/git/#{application}"
set :repository, "git@github.com:railsrumble/rr09-team-50.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

set :scm, :git
set :git_enable_submodules, 1
set :deploy_via, :remote_cache

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "antga.me"
role :web, "antga.me"
role :db,  "antga.me", :primary => true

after "deploy:update_code", "deploy:restart"
after "deploy:update_code", "deploy:link_shared_files"

# Overrides for Phusion Passenger
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  desc "link shared files"
  task :link_shared_files, :roles => [:app] do
    %w[config/database.yml].each do |f|
      run "ln -nsf #{shared_path}/#{f} #{release_path}/#{f}"
    end
  end
end
