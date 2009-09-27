class EmailSubscriptionsController < ApplicationController
  before_filter :find_email_subscription, :only => [:confirm, :unsubscribe, :destroy]
  
  def new
    @last_view = params[:last_view]
  end
  
  def create
    @email_subscription = EmailSubscription.new(params[:email_subscription])
    @email_subscription.filter = params[:filter]
    if @email_subscription.save
      flash[:notice] = "Your events have been sent to #{@email_subscription.email}."
      redirect_to(events_by_month_path(:year => 2009, :month => 'October', :filter => params[:filter], :view => params[:last_view]))
    else
      flash[:notice] = "There was a problem with your email address."
      render(:action => :new)
    end
  end
  
  def confirm
    @email_subscription.confirm!
  end
  
  def unsubscribe
  end
  
  def destroy
    @email_subscription.destroy
  end
  
protected
  
  def find_email_subscription
    @email_subscription = EmailSubscription.find_by_id_and_secret(params[:id], params[:secret])
    if @email_subscription
      true
    else
      redirect_to(root_path)
    end
  end
end
