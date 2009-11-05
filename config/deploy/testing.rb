require 'brightbox/recipes'
require 'brightbox/passenger'
set :rails_env, "production"

set :user, 'jamesd'

role :app, "thedextrousweb.com"
role :web, "thedextrousweb.com"
role :db,  "thedextrousweb.com", :primary => true

set :branch, "master"

set :deploy_to, "/var/vhosts/thedextrousweb.com/dev.learning/checkout"
