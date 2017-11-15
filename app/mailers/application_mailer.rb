# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "frontdesk@#{ENV.fetch('APP_DOMAIN')}"

  def setup_email(to, subject)
    return if dont_email(to)
    mail(
      to: to.respond_to?(:email) ? to.email : to,
      subject: subject,
      sent_on: Time.zone.now
    )
  end

  private

  def dont_email(object)
    invalid_email?(object.try(:email)) ||
      email_notifications_disabled?(object) ||
      email_address_not_confirmed?(object)
  end

  def invalid_email?(email)
    return false if email.nil?
    (email =~ Devise.email_regexp).nil?
  end

  def email_notifications_disabled?(obj)
    false
  end

  def email_address_not_confirmed?(obj)
    false
  end
end
