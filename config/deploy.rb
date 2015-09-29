require "bundler/capistrano"
load "config/deploy/figaro"

server "107.170.146.216", :web, :app, :db, :worker, primary: true

set :default_environment, { 'PATH' => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.npm_modules/bin:$PATH' }

set :application, "dg-api"
set :user, "mhayman"
set :port, 969
set :deploy_to, "/home/mhayman/setup/dg/api"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@bitbucket.org:michaelhayman/dg-api.git"
set :branch, "master"

set :normalize_asset_timestamps, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  desc "reload the database with seed data"
  task :seed, roles: :db do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
  after "deploy:update_code", "deploy:migrate"

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-available/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    sudo "cp #{current_path}/config/sidekiq.conf /etc/init/sidekiq.conf"
    sudo "cp #{current_path}/config/sidekiq-workers.conf /etc/init/sidekiq-workers.conf"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.vps.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/skylight.yml"), "#{shared_path}/config/skylight.yml"
    put File.read("config/apple_push_notification_production.pem"), "#{shared_path}/config/apple_push_notification_production.pem"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/skylight.yml #{release_path}/config/skylight.yml"
    run "ln -nfs #{shared_path}/config/apple_push_notification_production.pem #{release_path}/config/apple_push_notification_production.pem"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

