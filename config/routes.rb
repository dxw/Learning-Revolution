ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root    :controller => 'admin'
    admin.resources :venues, :collection => {:duplicates => [:get, :post], :moderations => [:get, :put]}
    admin.resources :events, :collection => {:duplicates => [:get, :post], :moderations => :get}, :member => {:moderate => :put}
    admin.resources :pages
  end
  
  map.root :controller => "pages"
  
  map.news '/news', :controller => 'pages', :action => 'news'
    
  map.events_by_month "/events/:year/:month.:format", :controller => 'events', :conditions => { :method => :get }, :format => 'html'
  map.events "/events", :controller => 'events', :action => "create", :conditions => { :method => :post }
  map.events_success "/events/success", :controller => 'events', :action => "success", :conditions => { :method => :get }
  map.find_venue_for_events "/events/venue", :controller => "events", :action => "find_venue", :conditions => {:method => :post}
  map.preview_events "/events/preview", :controller => "events", :action => "preview", :conditions => {:method => :post}
  map.with_options :path_prefix => "/events/:year/:month", :controller => 'events', :conditions => { :method => :get } do |events|
    events.event "/:day/:id.:format", :action => "show", :format => 'html'
  end
  map.venue_events "/venues/:venue_id/events/:year/:month", :controller => 'venues', :action => "events", :conditions => { :method => :get }

  map.pages '/:slug', :controller => 'pages', :action => 'show'
end
