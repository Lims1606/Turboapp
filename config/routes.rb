Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  resources :products
  root "messages#index"
  resources :messages do
    member do
      post :edit
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
