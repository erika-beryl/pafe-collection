Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/profile" => "users#show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'static_pages#top' 

  resources :shops do
    resources :parfaits, only: %i[new create edit update destroy show], shallow: true
  end

  resources :parfaits, only: %i[index]
  resources :reviews
end
