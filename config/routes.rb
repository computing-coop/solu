Rails.application.routes.draw do
  resources :backgrounds

  mount Ckeditor::Engine => '/ckeditor'
  resources :activities

  resources :posts
  get '/category/:id', to: "postcategories#show"

  resources :pages
  resources :groups
  resources :participants
  resources :activities
  
  namespace :admin do
    resources :activities
    resources :backgrounds
    resources :partners
    resources :postcategories
    resources :posts
    resources :subsites
    resources :symposia do
      resources :groups do
        resources :participants
      end
    end
    
    resources :calls do
      resources :submissions do
        resources :comments
        resources :votes
      end
    end
    resources :pages
    resources :users
  end
  resources :partners
  resources :home
  resources :calls do
    member do
      get :apply
    end
    collection do
      get :thanks
    end
  end
  resources :user
  resources :submissions
  
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'
  get '/admin',  to: 'admin/posts#index'
end
