# frozen_string_literal: true

module TwoFactorHelper
  def provisioning_uri
    Rack::Utils.escape current_member.provisioning_uri("#{Rails.application.class.parent_name}:#{current_member.email}")
  end

  def google_authenticator_qrcode
    image_tag(
      "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{provisioning_uri}",
      alt: 'Google Authenticator QRCode'
    )
  end

  def local_qrcode
    # %%TODO%% This doesn't work. Invalid code.
    RQRCode::QRCode.new(provisioning_uri).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4
    ).html_safe
  end
end

