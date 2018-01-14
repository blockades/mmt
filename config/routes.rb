# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, only: :invitations, controllers: { invitations: "admins/invitations" }

  devise_for :members, only: [:sessions, :passwords, :two_factor_authentications, :two_factor_recoveries],
                       path: :auth, path_names: {
                         sign_in: "login",
                         sign_out: "logout",
                         two_factor_authentication: "two_factor",
                         two_factor_recovery: "two_factor/recovery"
                       }

  devise_scope :members do
    get "auth/sudo" => "reauthentication#new", as: :new_reauthentication
    post "auth/sudo" => "reauthentication#create", as: :reauthentication
  end

  namespace :admins do
    root to: "dashboard#index"
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit]

    scope path: :deposit do
      get "/:coin_id/new" => "system_deposits#new", as: :new_coin_deposit
      post "/:coin_id/" => "system_deposits#create", as: :coin_deposit
    end

    scope path: :allocate do
      get "/:coin_id/new" => "system_allocations#new", as: :new_coin_allocation
      post "/:coin_id/" => "system_allocations#create", as: :coin_allocation
    end
  end

  namespace :settings, module: :members, as: :member_settings do
    get "/" => "settings#index"
    resource :password, only: [:new, :update]

    # ==> Two Factor Authentication
    get "two_factor_authentication" => "two_factor#index", as: :two_factor
    get "two_factor_authentication/resend_code" => "two_factor#resend_code", as: :resend_two_factor_code
    get "two_factor_authentication/recovery_codes" => "recovery_codes#show", as: :two_factor_recovery_codes
    get "two_factor_authentication/fallback_sms" => "fallback_sms#new", as: :new_two_factor_fallback_sms

    post "two_factor_authentication/fallback_sms" => "fallback_sms#create", as: :two_factor_fallback_sms
    post "two_factor_authentication/disable" => "two_factor#destroy", as: :disable_two_factor

    resource :two_factor_authentication, only: [:new, :create, :edit, :update],
                                         as: :two_factor,
                                         controller: :two_factor,
                                         path_names: { new: "setup", edit: "confirm" }
  end

  scope module: :members do
    root to: "dashboard#index"

    resources :coins, only: [:index]
    resources :coins, only: [:show], format: :js

    scope path: :exchanges do
      root to: "exchanges#index", as: :exchanges
      get "/:coin_id/new" => "exchanges#new", as: :new_exchange
      post "/:coin_id" => "exchanges#create", as: :exchange
    end

    scope path: :withdraw do
      root to: "withdrawls#index", as: :withdrawls
      get "/:coin_id" => "withdrawls#new", as: :new_withdrawl
      post "/:coin_id" => "withdrawls#create", as: :withdrawl
    end

    resources :members, path: "/", only: [:show, :update]
  end
end
