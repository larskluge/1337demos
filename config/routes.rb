ActionController::Routing::Routes.draw do |map|
  map.resources :categories

	#map.resources :cars

	# The priority is based upon order of creation: first created -> highest priority.

	# Sample of regular route:
	#   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#   map.resources :products

	# Sample resource route with options:
	#   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

	# Sample resource route with sub-resources:
	#   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

	# Sample resource route within a namespace:
	#   map.namespace :admin do |admin|
	#     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
	#     admin.resources :products
	#   end

	# You can have the root of your site routed with map.root -- just remember to delete public/index.html.
	map.root :controller => "welcome"

	# See how all your routes lay out with "rake routes"

	# admin area
	map.namespace :admin do |admin|
		admin.root :controller => 'welcomes'
		#map.connect '/admin', :controller => '/admin/welcomes', :layout => 'true'
		#map.connect '/admin/:controller/:action/:id'        , :layout => 'true'
	end



	# You can have the root of your site routed by hooking up ''
	# -- just remember to delete public/index.html.
	#map.connect '',
	#	:controller => 'welcome',
	#	:layout => 'true'

	# Allow downloading Web Service WSDL as a file with an extension
	# instead of a file named 'wsdl'
	#map.connect ':controller/service.wsdl', :action => 'wsdl'

	#map.connect 'demos/rss.xml',
	#	:controller => 'demos',
	#	:action => 'rss',
	#	:format => 'xml'
    #
	## thumbnail generation route
	map.connect 'images/maps/thumbs/:size/:id.jpeg',
		:controller => 'maps',
		:action => 'thumb',
		:requirements => { :size => /[0-9]+x[0-9]+/ }

	#map.connect ':controller/:action/:id/p/:page/partial',
	#	:layout => 'false'
    #
	#map.connect ':controller/:action/p/:page/partial',
	#	:layout => 'false'
    #
	#map.connect ':controller/:action/:id/partial',
	#	:layout => 'false'
    #
	#map.connect ':controller/:action/partial',
	#	:layout => 'false'
    #
	#map.connect ':controller/partial',
	#	:action => 'index',
	#	:layout => 'false'
    #
	#map.connect 'partial',
	#	:controller => 'welcome',
	#	:action => 'index',
	#	:layout => 'false'
    #
    #
    #
	#map.connect ':controller/:action/p/:page',
	#	:layout => 'true'
    #
#	#map.connect 'players/:layout',
#	#	:controller => 'players',
#	#	:action => 'index',
#	#	:requirements => { :layout => /true|false/ },
#	#	:layout => 'true'
#   #
#	#map.connect 'partials',
#	#	:controller => 'welcome',
#	#	:layout => 'false'
#   #
#	#map.connect 'partials/:controller/:action/:page',
#	#	:requirements => { :page => /\d+/ },
#	#	:layout => 'false',
#	#	:page => nil



	# Install the default routes as the lowest priority.
	map.connect ':controller/:action.:format'   # , :layout => 'true'
	map.connect ':controller/:action/:id'
	map.connect ':controller/:action/:id.:format'

	# Install the default routes with layout option
	map.connect ':controller/:action.:format'     , :layout => 'true'
	map.connect ':controller/:action/:id'         , :layout => 'true'
	map.connect ':controller/:action/:id.:format' , :layout => 'true'

end
