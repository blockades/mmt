# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "users#index"

  resources :plans, only: [:index, :new, :create]

  resources :user_plans, only: [:new, :create]
  resources :holdings
end
