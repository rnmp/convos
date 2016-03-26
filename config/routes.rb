Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'convos#index'

  resources :users
  get '/signup', to: 'users#new'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/my_convos', to: 'users#show'

  get '/tos', to: 'static_pages#tos'

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
