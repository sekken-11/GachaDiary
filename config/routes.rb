Rails.application.routes.draw do

  match '*path' => 'options_request#preflight', via: :options

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    resources :password_resets, only: %i[new create edit update]
    resources :users do
      collection do
        get 'me'
      end
    end
    resources :sessions
    resources :gachas
    resources :currency_packages
    resources :user_posses_stones
  end

  get '*path', to: 'home#index'
end
