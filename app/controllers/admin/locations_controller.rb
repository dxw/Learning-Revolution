class Admin::LocationsController < ApplicationController
  make_resourceful do
    actions :all
  end
end
