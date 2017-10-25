# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }

  devise_for :members, skip: [:registrations, :invitations], path: :auth, path_names: {
    sign_in: :login,
    sign_out: :logout,
    verify_authy: :verify_token,
    enable_authy: :enable_two_factor,
    verify_authy_installation: :verify_installation
  }

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
