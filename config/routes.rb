Rails.application.routes.draw do

  root 'comments#index'

  resources :comments, only: [:index, :create]
end
