Rails.application.routes.draw do
  resources :users do
    resources :items
  end

  resources :sessions, only: :create
end
