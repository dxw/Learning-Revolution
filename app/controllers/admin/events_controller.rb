class Admin::EventsController < Admin::AdminController
  
  before_filter :process_dates, :only => [:create, :update]
  
  make_resourceful do
    actions :all
    
    response_for :create do |format|
      format.html do 
        flash[:event] = "Event created successfully"
        redirect_to :action => :index
      end
    end
    
    response_for :update do |format|
      format.html do 
        flash[:event] = "Event saved successfully"
        return_or_redirect_to :action => :index
      end
    end
  end
  
  def index
    @events = Event.paginate(:all, :page => params[:page], :conditions => ["title LIKE ?", "%#{params[:title]}%"], :order => 'start')
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
  
  def moderate
    event = Event.find(params[:id])
    if params[:commit] == "Approve"
      event.approve!
      flash[:event] = "<em>#{event.title}</em> has been published"
    elsif params[:commit] == "Delete"
      event.destroy
      flash[:event] = "<em>#{event.title}</em> has been deleted"
    end
    redirect_to moderations_admin_events_path, :from => event.id
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
  
  def process_dates
    if params[:startday] and params[:starthour] and params[:startminute]
      d = params[:startday].to_i
      h = params[:starthour].to_i
      m = params[:startminute].to_i
      params[:event][:start] = Time.zone.local(2009, 10, d, h, m).to_s
    end
    if params[:endday] and params[:endhour] and params[:endminute]
      d = params[:endday].to_i
      h = params[:endhour].to_i
      m = params[:endminute].to_i
      begin
        params[:event][:end] = Time.zone.local(2009, 10, d, h, m).to_s
      rescue ArgumentError
      end
    end
  end
  
end
