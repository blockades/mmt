# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, only: [:sessions, :passwords], path: :auth, path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }

  scope module: :members do
    root to: "dashboard#index"
    resources :portfolios, only: [:show]

    resources :members, only: [:show, :update]
    get 'members/otp_auth/setup' => 'two_factor_authentication#setup', as: :setup_two_factor_authentication
    patch 'members/otp_auth/update' => 'two_factor_authentication#update', as: :update_two_factor_authentication
    get 'members/otp_auth/access_code' => 'two_factor_authentication#access_code', as: :two_factor_access_code
    patch 'members/otp_auth/confirm' => 'two_factor_authentication#confirm', as: :confirm_two_factor_authentication
  end

  namespace :admins do
    root to: 'dashboard#index'
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit]
  end
end
