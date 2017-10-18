# frozen_string_literal: true

module Members
  class QrCodesController < ApplicationController
    helper_method :qr_code_svg

    def create
      respond_to do |format|
        format.js
      end
    end

    def qr_code_svg
      RQRCode::QRCode.new(qr_code_params[:text]).as_svg(
        offset: 0, color: '000',
        shape_rendering: 'crispEdges',
        module_size: 8
      )
    end

    private

    def qr_code_params
      params.require(:qr_code).permit(:text)
    end
  end
end
