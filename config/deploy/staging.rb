set :rails_env, "production"

set :user, 'rails'

role :app, "staging.learnrev-001.vm.brightbox.net"
role :web, "staging.learnrev-001.vm.brightbox.net"
role :db,  "staging.learnrev-001.vm.brightbox.net", :primary => true

set :branch, "master"

set :deploy_to, "/home/rails/staging"
