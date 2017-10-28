module Members
  class TwoFactorAuthenticationController < ApplicationController
    include TwoFactorAuthenticationHelper

    def setup
    end

    def update
      if current_member.update(two_factor_params)
        if current_member.two_factor_enabled?
          redirect_to two_factor_access_code_path
        else
          redirect_to member_path(current_member)
        end
      else
        flash[:error] = "Failed"
        render 'setup'
      end
    end

    def access_code
      current_member.send_two_factor_authentication_code
    rescue Twilio::REST::RestError => e
      flash[:error] = e
    end

    def confirm
      if current_member.confirm_two_factor!(code_params[:code])
        redirect_to member_path(current_member), notice: "Two factor confirmed"
      else
        flash[:alert] = 'Code is invalid!'
        render 'setup'
      end
    end

    private

    def code_params
      params.require(:member).permit(:code)
    end

    def two_factor_params
      params.require(:member).permit(
        :phone_number,
        :two_factor_enabled,
      )
    end

  end
end
