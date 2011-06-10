#rvm stuff
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string,'ruby-1.9.2-p180' # Or whatever env you want it to run in.
set :rvm_type, :user
require 'bundler/capistrano'

set :application, "segmentupload"

set :use_sudo, false
#repository settings
set :scm, :git
set :deploy_via, :remote_cache
set :deploy_to, '$HOME/apps/segmentupload'

set :thin_binary, ""
set :thin_pid, "#{current_path}/tmp/pids/thin.pid"

role :web, "ec2-79-125-68-122.eu-west-1.compute.amazonaws.com"
role :app, "ec2-79-125-68-122.eu-west-1.compute.amazonaws.com"
role :db, "ec2-79-125-68-122.eu-west-1.compute.amazonaws.com" 
set :rails_env, :production
set :repository,  "git@github.com:mellterm/segmentupload.git"
set :branch, 'master'


namespace :deploy do
  %w(start stop restart).each do |action| 
       desc "#{action} the Thin processes"  
       task action.to_sym do
         find_and_execute_task("thin:#{action}")
      end
    end 
end


namespace :thin do  
  %w(start stop restart).each do |action| 
  desc "#{action} the app's Thin Cluster"  
    task action.to_sym, :roles => :app do  
      run "cd #{current_path} && rvmsudo bundle exec thin #{action} -p 80 -d -e production -c #{deploy_to}/current" 
    end
  end
end

