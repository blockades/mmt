# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }
  devise_for :members, only: [:sessions, :passwords, :two_factor_authentications, :two_factor_recoveries], path: :auth, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    two_factor_authentication: 'two_factor',
    two_factor_recovery: 'two_factor/recovery'
  }

  namespace :admins do
    root to: 'dashboard#index'
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit]
  end

  scope module: :members do
    root to: "dashboard#index"
    resources :portfolios, only: [:show]
    resource :password, only: [:new, :update]
    resource :two_factor, only: [] do
      get 'setup' => 'two_factor#GET_setup', as: :setup
      patch'setup' => 'two_factor#PATCH_setup', as: :update_setup
      get 'confirm' => 'two_factor#GET_confirm', as: :confirm
      patch 'confirm' => 'two_factor#PATCH_confirm', as: :update_confirm
      get 'disable' => 'two_factor#GET_disable', as: :disable
      patch 'disable' => 'two_factor#PATCH_disable', as: :update_disable
      patch 'cancel' => 'two_factor#cancel', as: :cancel
    end
    resources :members, path: '/', only: [:show, :update]
  end
end
