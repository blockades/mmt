# frozen_string_literal: true

module TwoFactorHelper
  def provisioning_uri
    current_member.otp_provisioning_uri(current_member.otp_provisioning_uri('MMT', issuer: "#{MMT}:#{current_member.email}"))
  end

  def google_authenticator_qrcode
    image_tag(
      "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{Rack::Utils.escape(provisioning_uri)}",
      alt: 'Google Authenticator QRCode'
    )
  end
end

