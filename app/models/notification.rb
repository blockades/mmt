# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'Member', foreign_key: :recipient_id, inverse_of: :notifications

  scope :unread, -> { where(read: false) }

  after_commit :broadcast, on: :create

  def channel
    "notifications_#{recipient_id}"
  end

  def broadcast
    Workers::Broadcaster.perform_async(
      channel: channel,
      data: {
        title: title,
        body: body,
        type: notification_type,
        count: self.recipient.notifications.unread.count
      }
    )
  end
end
