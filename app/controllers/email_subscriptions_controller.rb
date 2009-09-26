class EmailSubscriptionsController < ApplicationController
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
end
