# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, only: [:sessions, :passwords], path: :auth, path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }

  scope module: :members do
    root to: "dashboard#index"
    resources :portfolios, only: [:show]

    resources :members, only: [:show, :update] do
      collection do
        get 'otp_auth/setup' => 'two_factor#setup', as: :setup_two_factor
        patch 'otp_auth/update' => 'two_factor#update', as: :update_two_factor
        get 'otp_auth/code' => 'two_factor#code', as: :two_factor_code
        patch 'otp_auth/confirm' => 'two_factor#confirm', as: :confirm_two_factor
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
