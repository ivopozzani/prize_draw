# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resources :people, only: %i[create update destroy]
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
