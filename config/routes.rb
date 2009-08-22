ActionController::Routing::Routes.draw do |map|
  map.resources :anthills, :has_many => :ants
  map.resources :maps

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session
  
  map.dashboard '/dashboard', :controller => 'dashboard'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "static", :action => "index"

  # See how all your routes lay out with "rake routes"

  # No default catch all routes for security reasons.

end
