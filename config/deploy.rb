set :stages, %w(testing staging production)
set :default_stage, 'testing'
require 'capistrano/ext/multistage'

set :application, "learning_revolution"

default_run_options[:pty] = true
set :repository,  "git@github.com:dxw/Learning-Revolution.git"
set :scm, "git"
set :branch, "deploy"
set :git_shallow_clone, 1


set :symlinked_dirs, [
  # ['index', 'search/index']
]

namespace :deploy do
  
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
     
  desc "Creates additional symlinks and restarts sphinx"
  task :before_update_code do
    if symlinked_dirs
      symlinked_dirs.each do |item| 
        src, dest = item
        run "ln -nfs #{storage_path}/#{dest} #{current_path}/#{src}"
      end
    end
    run "ln -fs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
  
end

# rake spec --format html:public/specs.html
