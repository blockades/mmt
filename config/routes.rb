# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }
  devise_for :members, only: [:sessions, :passwords, :two_factor_authentications, :two_factor_recoveries], path: :auth, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    two_factor_authentication: 'two_factor',
    two_factor_recovery: 'two_factor/recovery'
  }


  scope module: :members do
    root to: "dashboard#index"
    resources :portfolios, only: [:show]

    resources :members, only: [:show, :update] do
      member do
        patch 'members/:id/update_password' => 'members#update_password', as: :update_password
      end

      collection do
        get 'otp_auth/setup' => 'two_factor#GET_setup', as: :setup_two_factor
        patch 'otp_auth/setup' => 'two_factor#PATCH_setup', as: :update_setup_two_factor

        get 'otp_auth/confirm' => 'two_factor#GET_confirm', as: :confirm_two_factor
        patch 'otp_auth/confirm' => 'two_factor#PATCH_confirm', as: :update_confirm_two_factor

        get 'otp_auth/disable' => 'two_factor#GET_disable', as: :disable_two_factor
        patch 'otp_auth/disable' => 'two_factor#PATCH_disable', as: :update_disable_two_factor
      end
    end
  end

  namespace :admins do
    root to: 'dashboard#index'
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit]
  end
end
