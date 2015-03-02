Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :activities

  resources :posts

  resources :pages

  namespace :admin do
    resources :activities
    resources :partners
    resources :posts
    resources :calls do
      resources :submissions
    end
    resources :pages
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
  resources :submissions
  
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get '/admin',  to: 'admin/posts#index'
end
