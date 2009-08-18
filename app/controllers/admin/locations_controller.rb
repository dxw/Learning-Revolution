class Admin::LocationsController < Admin::AdminController
  make_resourceful do
    actions :all
    
    response_for :create do |format|
      format.html do 
        redirect_to :action => :index
        flash[:location] = "Location created successfully"
      end
    end
    
    response_for :update do |format|
      format.html do 
        redirect_to :action => :index
        flash[:location] = "Location saved successfully"
      end
    end
  end
end
