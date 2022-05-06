Rails.application.routes.draw do
  root "boards#index"

  resources :boards do
    resources :fields
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
