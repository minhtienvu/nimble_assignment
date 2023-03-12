Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'statistics#index'

  resources :statistics

  as :user do
    get 'signin' => 'devise/sessions#new'
    post 'signin' => 'devise/sessions#create'
    delete 'signout' => 'devise/sessions#destroy'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/login', to: 'external/auth#login'
      get '/statistics', to: 'external/statistics#index'
      post '/statistics/upload', to: 'external/statistics#upload'
    end
  end
end
