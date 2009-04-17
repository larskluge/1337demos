ActionController::Routing::Routes.draw do |map|



  # admin area ################################################################

  map.namespace :admin do |admin|
    admin.root :controller => 'welcomes'

    admin.resource :welcomes, :only => :index, :member => {:delete_cache => :delete}

    admin.resources :announcements, :active_scaffold => true
    admin.resources :comments
    admin.resources :demos
    admin.resources :nicknames, :active_scaffold => true
    admin.resources :players, :member => {:merge => :get}, :collection => {:merge_players => :put}
    admin.resources :shoutboxes
    admin.resources :stuffs, :active_scaffold => true
  end



  # normal ####################################################################

  map.root :controller => "welcomes"

  # support old demos feed url
  # TODO: remove this old route
  map.connect 'demos/rss.xml', :controller => 'demos', :action => 'index', :format => 'atom'

  map.resource :check, :member => {:fail => :get}
  map.resource :welcome, :only => :index, :collection => {:create_comment => :post}

  map.resources :announcements, :only => [:index, :show]
  map.resources :categories
  map.resources :comments
  map.resources :demofiles
  map.resources :demos, :collection => {:race => :get, :freestyle => :get}, :member => {:verify => :get, :create_comment => :post}
  map.resources :maps, :collection => {:clearsearch => :get, :search => :post}
  map.resources :players
  map.resources :ratings, :member => {:rate => :post}
  map.resources :stuffs, :collection => {:thanks => :get}
  map.resources :videos



  # webservices ###############################################################

  map.namespace :webservices do |ws|
    ws.update_demo 'update_demo/:id', :action => :update_demo, :conditions => {:method => :get}
  end



  # thumbnail generation route ################################################

  map.connect 'images/maps/thumbs/:size/:id.jpeg',
    :controller => 'maps',
    :action => 'thumb',
    :requirements => {:size => /[0-9]+x[0-9]+/}



end

