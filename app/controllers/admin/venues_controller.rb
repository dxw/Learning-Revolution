class Admin::VenuesController < Admin::AdminController
  make_resourceful do
    actions :all
    
    response_for :create do |format|
      format.html do 
        redirect_to :action => :index
        flash[:venue] = "Venue created successfully"
      end
    end
    
    response_for :update do |format|
      format.html do 
        redirect_to :action => :index
        flash[:venue] = "Venue saved successfully"
      end
    end
  end
  
  def duplicates
    fix_duplicate if request.method == :post && params[:venue]
    @duplicate_venues = Venue.find(:all, :conditions => "possible_duplicate_id IS NOT NULL")
  end
  
  private
  
  def fix_duplicate
    duplicate = Venue.find(params[:venue].keys.first)
    if params[:venue][duplicate.id.to_s] == "Remove new venue"
      flash[:duplicates] = "#{duplicate.name} was deleted"
      duplicate.fix_duplicate(:self)
    elsif params[:venue][duplicate.id.to_s] == "Remove original venue"
      flash[:duplicates] = "#{duplicate.possible_duplicate.name} was deleted"
      duplicate.fix_duplicate(:original)
    end
  end
  
end
