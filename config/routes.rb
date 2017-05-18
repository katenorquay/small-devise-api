Rails.application.routes.draw do
  devise_for :users, only: []

  namespace :v1, defaults: {format: :json} do
    resource :sessions, only: [:create, :destroy], controller: :sessions
    resources :users, only: [:create, :update, :destroy]
    resources :stories, only: [:index, :show, :create]
  end
end
