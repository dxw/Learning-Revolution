ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root    :controller => 'admin'
    admin.resources :venues, :collection => {:duplicates => [:get, :post], :moderations => [:get, :put]}
    admin.resources :events, :collection => {:duplicates => [:get, :post], :moderations => :get}, :member => {:moderate => :put}
  end
end
