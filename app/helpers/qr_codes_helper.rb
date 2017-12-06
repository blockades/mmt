# frozen_string_literal: true

module QrCodesHelper
  def provisioning_uri
    current_member.provisioning_uri(current_member.email, issuer: Rails.application.class.parent_name)
  end

  def qr_code_as_html(uri)
    RQRCode::QRCode.new(uri, size: 8, level: :h)
  end

  def google_authenticator_qrcode
    image_tag(
      "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{Rack::Utils.escape provisioning_uri}",
      alt: "Google Authenticator QRCode"
    )
  end
end
