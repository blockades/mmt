# frozen_string_literal: true

module TwoFactorAuthenticationHelper
  def google_authenticator_qrcode(member)
    image_tag(
      "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{Rack::Utils.escape(member.provisioning_uri)}",
      alt: 'Google Authenticator QRCode'
    )
  end
end
