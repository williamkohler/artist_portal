Rails.application.routes.draw do

  root 'static_pages#home'
  get 'sessions/new'

  get '/about',       to: 'static_pages#about'
  get '/landing',     to: 'static_pages#landing'
  get '/login',       to: 'sessions#new'
  get '/signup',      to: 'users#new'
  post '/login',      to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  resources :account_activations,        only: [:edit]
  resources :artist_relationships,       only: [:create, :destroy]
  resources :contact_venue_relationships, only: [:create, :destroy]
  resources :password_resets,            only: [:new, :create, :edit, :update]
  resources :shows,                      only: [:new, :create, :edit, :update,
                                                :destroy]
  resources :shows, :users, :artists
  resources :contacts, :venues do
    member do
      get :shows
    end
  end
end
