ActionController::Routing::Routes.draw do |map|
  map.connect '*path', :controller => "application", :action => "catcher"
end
