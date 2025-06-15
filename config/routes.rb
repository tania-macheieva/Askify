Rails.application.routes.draw do
  get "errors/not_found"
  get "errors/internal_server_error"
  root to: "users#index"

  get "/sign_in", to: "sessions#new", as: :sign_in
  get "/sign_up", to: "users#new", as: :sign_up

  resource :session, only: %i[create destroy]
  resources :users, param: :nickname, only: %i[new create edit update destroy show index]
  resources :questions

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
