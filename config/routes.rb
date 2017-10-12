# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, skip: [:registrations], controllers: { invitations: 'admins/invitations' }

  scope module: :members do
    root to: "dashboard#index"
    resources :members, only: [:index, :show, :update]
    get 'profile', to: 'members#show', as: :profile
    resources :holdings, only: [:index, :edit]
    resources :portfolios, only: [:index, :edit]
  end

  namespace :admins do
    root to: 'dashboard#index'
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit, :update]
  end
end
