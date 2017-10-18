# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, only: [:sessions, :passwords], path: :auth, path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }

  scope module: :members do
    root to: "dashboard#index"
    resources :members, only: [:show, :update]
    resources :portfolios, only: [:show]
  end

  namespace :admins do
    root to: 'dashboard#index'
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit]
  end
end
