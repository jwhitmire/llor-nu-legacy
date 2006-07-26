ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # those waiting to play
  map.connect '/join/', :controller => 'user', :action => 'signup'
  map.connect '/letmein/', :controller => 'waiters', :action => 'notify_me'
  map.connect '/thanks/', :controller => 'waiters', :action => 'thanks'


  map.connect '/', :controller => 'play', :action => 'home'
  map.connect '/play', :controller => 'js', :action => 'index'
  map.connect '/play_immersed/', :controller => 'js', :action => 'fullscreen'
  map.connect '/play/index', :controller => 'js', :action => 'index'

  map.connect 'js/:action', :controller => 'js'


  # user shortcuts
  map.login '/login/', :controller => 'user', :action => 'login'
  map.connect '/logout/', :controller => 'user', :action => 'logout'
  map.connect '/settings/', :controller => 'user', :action => 'edit'
  map.connect '/forgot/', :controller => 'user', :action => 'forgot_password'
  map.connect '/change/', :controller => 'user', :action => 'change_password'
  map.connect '/changed/', :controller => 'user', :action => 'change_password_non_auth'
  map.connect '/signup', :controller => 'user', :action => 'signup'

  map.connect '/stats/', :controller =>'statistics', :action => 'index'
  map.connect '/help/', :controller => 'help', :action => 'index'
  map.connect '/build/',       :controller => 'deeds', :action => 'build'
  map.building_list '/buildings/',   :controller => 'deeds', :action => 'list'
  map.building_show '/building/:id', :controller => 'deeds', :action => 'show'
  map.connect '/upgrade/:id',  :controller => 'deeds', :action => 'upgrade'
  map.connect '/sell/:id',     :controller => 'deeds', :action => 'sell'
  map.connect '/inventory/',   :controller => 'inventory', :action => 'index'
  map.connect '/inventory/:action', :controller => 'inventory'
  map.connect '/admin/:action', :controller => 'admin'
  map.connect '/instances/:action', :controller => 'instances'

  # map user actions still
  map.connect 'user/:action', :controller => 'user'

  # map most actions to play controller
  map.connect ':action', :controller => 'play'
  map.connect ':action/:id', :controller => 'play'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
