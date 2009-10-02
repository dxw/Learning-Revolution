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
  
  def index
    if params.andand[:filter].andand[:q].present?
      conditions = "(name LIKE ? OR address_1 LIKE ? OR address_2 LIKE ? OR address_3 LIKE ? OR city LIKE ? OR county LIKE ? OR postcode LIKE ? )"
      cond_lst = ["%#{params[:filter][:q]}%"] * 7
    else
      conditions = ""
      cond_lst = []
    end
    @venues = Venue.paginate(:all, :page => params[:page], :conditions => [conditions]+cond_lst, :order => "name")
  end
  
  def duplicates
    fix_duplicate if request.method == :post && params[:venue]
    @duplicate_venues = Venue.find(:all, :conditions => "possible_duplicate_id IS NOT NULL AND (not_a_dup != TRUE OR not_a_dup IS NULL)").select{|v|v.possible_duplicate.present?}
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
    elsif params[:venue][duplicate.id.to_s] == "Not a duplicate"
      flash[:duplicates] = "#{duplicate.name} has been marked as not a duplicate"
      duplicate.not_a_dup = true
      duplicate.save!
    end
  end
  
end
