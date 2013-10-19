require 'bundler/capistrano'
require 'capistrano_colors'
require 'rvm/capistrano'
load 'deploy/assets'

set :application,                "hotfix"

server "173.255.247.113",           :app, :web, :db, :primary => true

set :scm,                        :git
set :repository,                 "https://github.com/railsrumble/r13-team-41.git"
set :branch,                     "master"


set :rails_env,                  "production"
set :deploy_to,                   "/home/apps/hotfix/"
set :domain,                     "binarycode.r13.railsrumble.com"
set :use_sudo,                   false
set :user,                       "apps"


set :rvm_ruby_string,            'ruby-2.0.0-p247'
set :rvm_type, :user

set :deploy_via,    :remote_cache
set :ssh_options, forward_agent: true
set :keep_releases, 10
set :default_run_options, pty: true

set :shared_children, shared_children + %w{public/uploads}

after "bundle:install", "deploy:link_configs"
after "deploy:update_code", "deploy:migrate"
after "deploy", "deploy:cleanup"

default_environment['APP_ROOT']     = current_path
default_environment['SOCKET_ABBR']  = application
default_environment['WORKERS']      = 3

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

namespace :deploy do
  task :start, except: { no_release: true } do
    unless remote_file_exists?(File.join(current_path, "tmp", "pids"))
      run "cd #{current_path}/tmp ; mkdir pids"
    end

    run "cd #{current_path} ; bundle exec unicorn -c #{current_path}/config/unicorn.rb -E #{rails_env} -D"
  end

  task :stop, except: { no_release: true } do
    run "kill -s QUIT `cat /tmp/unicorn_#{application}.pid`"
  end

  task :restart, except: { no_release: true } do
    if remote_file_exists?("/tmp/unicorn_#{application}.pid")
      run "kill -s USR2 `cat /tmp/unicorn_#{application}.pid`"
    else
      deploy.start
    end
  end

  task :stop_with_cron, except: { no_release: true } do
    deploy.stop
    whenever.clear_crontab
  end

  task :start_with_cron, except: { no_release: true } do
    deploy.start
    whenever.update_crontab
  end

  task :link_configs do
    #run "ln -sF #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -sF #{deploy_to}/shared/config/application.yml #{release_path}/config/application.yml"
  end

  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
  end
end

namespace :log do
  desc "A pinch of tail"
  task :tailf, :roles => :app do
    run "tail -n 10000 -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
      puts "#{data}"
      break if stream == :err
    end
  end
end
