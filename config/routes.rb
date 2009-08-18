ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :locations
    admin.resources :events
  end
end
