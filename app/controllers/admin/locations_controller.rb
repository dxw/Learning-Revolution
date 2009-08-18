class Admin::LocationsController < ApplicationController
  make_resourceful do
    actions :all
    
    response_for :create do |format|
      format.html do 
        redirect_to :action => :index
        flash[:location] = "Location created succesfully"
      end
    end
  end
end
