LeetdemosPlatform::Application.routes.draw do |map|
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'





  # admin area ################################################################

  map.namespace :admin do |admin|
    admin.root :controller => 'welcomes'

    admin.resource :welcomes, :only => :index, :member => {:delete_cache => :delete}

    admin.resources :announcements, :active_scaffold => true
    admin.resources :comments
    admin.resources :demos
    admin.resources :nicknames, :active_scaffold => true
    admin.resources :players, :member => {:merge => :get}, :collection => {:merge_players => :put}
    admin.resources :shoutboxes, :only => :index
    admin.resources :stuffs, :active_scaffold => true
  end


  # normal ####################################################################

  map.root :controller => "welcomes"

  map.resource :check, :member => {:fail => :get}
  map.resource :welcomes, :only => :index, :collection => {:create_comment => :post}

  map.resources :announcements, :only => [:index, :show]
  map.resources :categories
  map.resources :comments
  map.resources :demofiles
  map.resources :demos, :collection => {:race => :get, :freestyle => :get}, :member => {:verify => :get, :create_comment => :post}
  map.resources :maps, :collection => {:clearsearch => :get, :search => :post}
  map.resources :players
  map.resources :ratings, :member => {:rate => :post}
  map.resources :stuffs, :collection => {:thanks => :get}

  map.list_demos_test '/tests/list_demos', :controller => 'tests', :action => 'list_demos', :conditions => {:method => :get}

  map.resources :videos, :only => :show, :defaults => {:format => "mp4"}

  # webservices ###############################################################

  map.render_request '/webservices/render_request.:format', :controller => 'webservices', :action => 'render_request', :conditions => {:method => :get}
  map.update_demo '/webservices/update_demo/:id', :controller => 'webservices', :action => 'update_demo', :conditions => {:method => :get}


  # thumbnail generation route ################################################

  map.connect 'images/maps/thumbs/:size/:id.jpeg',
    :controller => 'maps',
    :action => 'thumb',
    :requirements => {:size => /[0-9]+x[0-9]+/}
end

