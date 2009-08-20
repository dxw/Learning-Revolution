class Admin::EventsController < Admin::AdminController
  make_resourceful do
    actions :all
    
    response_for :create do |format|
      format.html do 
        redirect_to :action => :index
        flash[:event] = "Event created successfully"
      end
    end
    
    response_for :update do |format|
      format.html do 
        redirect_to :action => :index
        flash[:event] = "Event saved successfully"
      end
    end
  end
  
  def duplicates
    fix_duplicate if request.method == :post && params[:event]
    @duplicate_events = Event.find(:all, :conditions => "possible_duplicate_id IS NOT NULL")
  end
  
  def moderations
    if params[:from]
      @event = Event.find(:first, :conditions => ["(published IS NULL OR published != 1) AND id > ?", params[:from]], :order => "id ASC")
    else
      @event = Event.find(:first, :conditions => "published IS NULL OR published != 1", :order => "created_at ASC")
    end
  end
  
  private
  
  def fix_duplicate
    duplicate = Event.find(params[:event].keys.first)
    if params[:event][duplicate.id.to_s] == "Remove new event"
      flash[:duplicates] = "#{duplicate.title} was deleted"
      duplicate.fix_duplicate(:self)
    elsif params[:event][duplicate.id.to_s] == "Remove original event"
      flash[:duplicates] = "#{duplicate.possible_duplicate.title} was deleted"
      duplicate.fix_duplicate(:original)
    end
  end
end
