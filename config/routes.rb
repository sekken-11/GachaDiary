Rails.application.routes.draw do
  root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    resources :users do
      collection do
        get 'me'
      end
    end
    resources :sessions
  end

  get '*path', to: 'home#index'
end
