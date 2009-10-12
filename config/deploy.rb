set :stages, %w(testing staging production)
set :default_stage, 'testing'
require 'capistrano/ext/multistage'

set :application, "learning_revolution"

default_run_options[:pty] = true
set :repository,  "git@github.com:dxw/Learning-Revolution.git"
set :scm, "git"
set :branch, "deploy"
set :git_shallow_clone, 1

set :local_shared_files, [
  'config/database.yml',
  'config/application.yml',
  'config/404ignore',
  'public/badges',
  'public/images/featured_photos'
]

namespace :deploy do
  
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
     
end

# rake spec --format html:public/specs.html
