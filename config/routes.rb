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
    resources :members, only: [:index, :new, :create]
    resources :members, only: [:show], format: :js

    resources :system_transactions, as: :transactions, only: [:index], format: :js

    scope path: :deposit do
      get "/:coin_id/new" => "system_deposits#new", as: :new_coin_deposit
      post "/:coin_id/" => "system_deposits#create", as: :coin_deposit
      get "/:coin_id/prev" => "system_allocations#prev", as: :previous_deposit, format: :js
    end

    scope path: :allocate do
      get "/:coin_id/new" => "system_allocations#new", as: :new_coin_allocation
      post "/:coin_id/" => "system_allocations#create", as: :coin_allocation
      get "/:coin_id/prev" => "system_allocations#prev", as: :previous_allocation, format: :js
    end

    scope path: :withdraw do
      get "/:coin_id/new" => "system_withdrawls#new", as: :new_withdrawl
      post "/:coin_id" => "system_withdrawls#create", as: :withdrawl
    end
  end

  namespace :settings, module: :members, as: :member_settings do
    get "/" => "settings#index"
    resource :password, only: [:new, :update]

    resource :two_factor_authentication, only: [:new, :create, :edit, :update, :destroy],
                                         path_names: { new: "setup", edit: "confirm", destroy: "disable" } do
      get "/" => "two_factor_authentications#index"
      get "recovery_codes" => "recovery_codes#show", as: :recovery_codes
      post "code" => "two_factor_authentications#code", as: :send_code
    end
  end

  scope module: :members do
    root to: "dashboard#index"

    resources :coins, only: [:index]
    resources :coins, only: [:show], format: :js

    if ENV["EXCHANGE"]
      scope path: :exchanges do
        root to: "exchanges#index", as: :exchanges
        get "/:coin_id/new" => "exchanges#new", as: :new_exchange
        post "/:coin_id" => "exchanges#create", as: :exchange
      end
    end

    if ENV["WITHDRAWL"]
      scope path: :withdraw do
        root to: "withdrawls#index", as: :withdrawls
        get "/:coin_id/new" => "withdrawls#new", as: :new_withdrawl
        post "/:coin_id" => "withdrawls#create", as: :withdrawl
      end
    end

    resources :members, path: "/", only: [:show, :update]
  end
end
