LeetdemosPlatform::Application.routes.draw do

  # admin area ################################################################

  namespace :admin do
    root :to => 'welcomes#index'

    resource :welcomes, :only => :index do
      member do
        delete :delete_cache
      end
    end

    resources :announcements do
      as_routes
    end

    resources :nicknames do
      as_routes
    end

    resources :stuffs do
      as_routes
    end

    resources :comments
    resources :shoutboxes, :only => :index

    resources :demos do
      member do
        put :rerender
      end
    end

    resources :players do
      member do
        get :merge
      end

      collection do
        put :merge_players
      end
    end
  end


  # normal ####################################################################

  root :to => "welcomes#index"

  resource :check, :only => [] do
    member do
      get :fail
    end
  end

  resources :welcomes, :only => :index do
    collection do
      post :create_comment
    end
  end

  resources :announcements, :only => [:index, :show]
  resources :comments, :only => :index
  resources :demofiles, :only => [:index, :new, :create]

  resources :demos, :only => [:index, :show, :update] do
    member do
      get :verify
      post :create_comment
    end

    collection do
      get :race
      get :freestyle
    end
  end

  resources :maps do
    collection do
      get :clearsearch
      post :search
    end
  end

  resources :players
  resources :ratings do
    member do
      post :rate
    end
  end

  resources :stuffs do
    collection do
      get :thanks
    end
  end

  resources :videos, :only => :show, :defaults => {:format => "mp4"}


  # webservices ###############################################################

  match '/webservices/render_request.:format' => 'webservices#render_request', :as => :render_request
  match '/webservices/update_demo/:id' => 'webservices#update_demo', :as => :update_demo


  # thumbnail generation route ################################################

  match 'images/maps/thumbs/:size/:id.jpeg' => 'maps#thumb', :constraints => {:size => /[0-9]+x[0-9]+/}

end

