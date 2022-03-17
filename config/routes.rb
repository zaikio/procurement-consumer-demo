Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "/dashboard", as: :dashboard do
    get "/", to: "dashboard#index"

    resources :suppliers,             only: [:index, :show]
    resources :contract_requests,     only: [:new, :create]
    resources :material_requirements, only: [:index, :show, :create]
    resources :orders,                only: [:index, :show, :create]

    resources :variants, only: [:index, :show] do
      match :search, on: :collection, via: %i(get post)
    end
  end

  # Authentication
  get "/auth/:provider/callback", to: "sessions#callback"
  post :logout, to: "sessions#logout"
  root to: "sessions#login"
end
