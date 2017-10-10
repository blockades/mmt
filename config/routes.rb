# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :members, skip: [:registrations], controllers: { invitations: 'admin/invitations' }

  root to: "members#index"
  resources :holdings

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :portfolios, only: [:index, :new, :create, :show]
    resources :coins, only: [:index, :edit, :update]
    resources :members, only: [:index, :new, :create, :edit, :update]
  end
end
