Rails.application.routes.draw do
  root to: "users#index"

  get "/sign_in", to: "sessions#new", as: :sign_in
  get "/sign_up", to: "users#new", as: :sign_up

  resource :session, only: %i[create destroy]
  resources :users, param: :nickname, only: %i[new create edit update destroy show index]
  resources :questions

  match "/test_404", to: "errors#not_found", via: :all
  match "/test_500", to: "errors#internal_server_error", via: :all

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
