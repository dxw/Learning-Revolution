ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root    :controller => 'admin'
    admin.resources :venues, :collection => {:duplicates => [:get, :post]}
    admin.resources :events, :collection => {:duplicates => [:get, :post]}
  end
end
