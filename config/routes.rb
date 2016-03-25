Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'convos#index'

  resources :users
  get '/signup' => 'users#new'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/tos' => 'static_pages#tos'

  resources :topics

  resources :convos do
    member do
      get 'upvote'
      get 'downvote'
    end
  end

  get '/topics/:topic_slug/:id/:convo_slug', to: 'convos#show', as: :convo_slug

  get '/notifications', to: 'notifications#index'

  resources :comments do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
end
