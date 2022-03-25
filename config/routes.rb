# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    resources :people, only: %i[index create update destroy]
    get '/people/prizes' => 'prizes#index'
    post '/people/prizes' => 'prizes#create'
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
