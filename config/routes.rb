Rails.application.routes.draw do
  root to: "users#index"

  resources :questions
  resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create edit update destroy show index]
end
