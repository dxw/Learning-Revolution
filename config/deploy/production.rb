require 'brightbox/recipes'
require 'brightbox/passenger'
set :domain, "production.learnrev-001.vm.brightbox.net"

set :rails_env, "production"

set :user, 'rails'

role :app, "production.learnrev-001.vm.brightbox.net"
role :web, "production.learnrev-001.vm.brightbox.net"
role :db,  "production.learnrev-001.vm.brightbox.net", :primary => true

set :branch, "production"

set :deploy_to, "/home/rails/default"
