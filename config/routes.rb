ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root    :controller => 'admin'
    admin.resources :venues, :collection => {:duplicates => [:get, :post], :moderations => [:get, :put]}
    admin.resources :events, :collection => {:duplicates => [:get, :post], :moderations => :get}, :member => {:moderate => :put}
  end
  
  map.root :controller => "pages"
  
  map.events "/events/:year/:month", :controller => 'events', :conditions => { :method => :get }
  map.with_options :path_prefix => "/events/:year/:month", :controller => 'events', :conditions => { :method => :get } do |events|
    events.days_events "/:day", :action => "show"
    events.event "/:day/:id", :action => "show"
  end
  map.venue_events "/venues/:venue_id/events/:year/:month", :controller => 'venues', :action => "events", :conditions => { :method => :get }
end
