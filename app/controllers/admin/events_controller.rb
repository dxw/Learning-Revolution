class Admin::EventsController < Admin::AdminController

  include ActionControllerExtra::EventsMixin

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
    a = "%#{params[:title]}%"
    arr = []
    cond = %w[title description theme event_type cost min_age organisation contact_name contact_phone_number contact_email_address].map{|field|arr<<a;"#{field} LIKE ?"}.join(' OR ')
      @events = Event.paginate(:all, :page => params[:page], :conditions => [cond]+arr, :order => 'start, title')
  end

  def count_unpublished
    @count_unpublished ||= Event.unpublished.count
  end

  def edit
    update_date_params @event

    params.merge!({:event => {:event_type => @event.event_type, :theme => @event.theme}})
  end

  def duplicates
    fix_duplicate if request.method == :post && params[:event]
    @duplicate_events = Event.find(:all, :conditions => "possible_duplicate_id IS NOT NULL AND (not_a_dup != TRUE OR not_a_dup IS NULL)").select{|e|e.possible_duplicate.present?}
  end

  def moderations
    count_unpublished

    if params[:from]
      @event = Event.find(:first, :conditions => ["(published IS NULL OR published != 1) AND id = ?", params[:from]], :order => "id ASC")
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
    elsif params[:event][duplicate.id.to_s] == "Not a duplicate"
      flash[:duplicates] = "#{duplicate.title} has been marked as not a duplicate"
      duplicate.not_a_dup = true
      duplicate.save!
    end
  end
end
