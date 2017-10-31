# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }
  devise_for :members, only: [:sessions, :passwords, :two_factor_authentications, :two_factor_recoveries], path: :auth, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    two_factor_authentication: 'two_factor',
    two_factor_recovery: 'two_factor/recovery'
  }

  devise_scope :members do
    get 'auth/sudo' => 'reauthentication#new', as: :new_reauthentication
    post 'auth/sudo' => 'reauthentication#create', as: :reauthentication
  end

  namespace :admins do
    root to: 'dashboard#index'
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit]
  end

  scope module: :members do
    root to: "dashboard#index"
    resources :portfolios, only: [:show]

    scope :settings do
      get '/' => 'settings#index', as: :settings
      resource :password, only: [:new, :update]

      # ==> Two Factor Authentication
      get 'two_factor_authentication' => 'two_factor#index', as: :two_factor
      get 'two_factor_authentication/recovery_codes' => 'recovery_codes#index', as: :two_factor_recovery_codes
      get 'two_factor_authentication/fallback_sms' => 'fallback_sms#index', as: :two_factor_fallback_sms
      post 'two_factor_authentication/disable' => 'two_factor#destroy', as: :disable_two_factor
      resource :two_factor_authentication, only: [:new, :create, :edit, :update],
        as: :two_factor, controller: :two_factor, path_names: { edit: 'confirm' }
    end

    resources :members, path: '/', only: [:show, :update]
  end
end
