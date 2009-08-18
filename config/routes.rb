ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root    :controller => 'admin'
    admin.resources :venues
    admin.resources :events
  end
end
