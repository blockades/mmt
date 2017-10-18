# frozen_string_literal: true

module Members
  class QrCodesController < ApplicationController

    def new
    end

    def create
      respond_to do |format|
        format.svg do
          render inline: RQRCode::QRCode.new(qr_code_params[:text]).as_svg(
            offset: 0, color: '000',
            shape_rendering: 'crispEdges',
            module_size: 8
          )
        end
      end
    end

    private

    def qr_code_params
      params.require(:qr_code).permit(:text)
    end

  end
end
