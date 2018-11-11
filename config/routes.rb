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

    resources :transactions, only: [] do
      resources :comments, only: :create, controller: :transaction_comments, format: :js
    end

    resources :coins, only: [:index, :edit, :show, :update] do
      resources :assets, only: [:index, :show]
      resources :liabilities, only: [:index, :show]
    end

    resources :members, only: [:index, :new, :create]
    resources :members, only: [:show], format: :js

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
    resource :password, only: [:edit, :update]

    resource :two_factor_authentication, only: [:new, :create, :edit, :update, :destroy],
                                         path_names: { new: "setup", edit: "confirm", destroy: "disable" } do
      get "/" => "two_factor_authentications#index"
      get "recovery_codes" => "recovery_codes#show", as: :recovery_codes
      post "code" => "two_factor_authentications#code", as: :send_code
    end
  end

  scope module: :members do
    root to: "dashboard#index"

    resources :coins, only: [:index] do
      resources :liabilities, only: :index
    end

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

    if ENV["DEPOSIT"]
      scope path: :deposit do
        root to: "deposits#index", as: :deposits
        get "/:coin_id/new" => "deposits#new", as: :new_deposit
        post "/:coin_id" => "deposits#create", as: :deposit
      end
    end

    if ENV["GIFT"]
      scope path: :gift do
        root to: "gifts#index", as: :gifts
        get "/:coin_id/new" => "gifts#new", as: :new_gift
        post "/:coin_id" => "gifts#create", as: :gift
      end
    end

    resources :members, path: "/", only: [:show, :update]
  end
end
