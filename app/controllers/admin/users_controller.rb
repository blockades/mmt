# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def edit
      user
    end

    def create
      user = User.new permitted_params
      if user.save
        flash[:success] = "User created"
        redirect_to action: :index
      else
        flash[:error] = "User failed to be created"
        render :new
      end
    end

    private

    def permitted_params
      params.require(:user).permit :email, :password
    end
  end
end

