Rails.application.routes.draw do
  root to: "users#index"

  get "/sign_in", to: "sessions#new", as: :sign_in
  get "/sign_up", to: "users#new", as: :sign_up

  resource :session, only: %i[create destroy]
  resources :users, param: :nickname, only: %i[new create edit update destroy show index]
  resources :questions
end
