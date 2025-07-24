Rails.application.routes.draw do
  resources :products
  root "products#index"
  resources :messages do
    member do
      post :edit
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
