LeetdemosPlatform::Application.routes.draw do

  # normal ####################################################################
  #

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

    member do
      get :best_demo
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


  # admin area ################################################################
  #

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

end

