Rails.application.routes.draw do
  root "messages#index"
  resources :messages
  get "up" => "rails/health#show", as: :rails_health_check
end
