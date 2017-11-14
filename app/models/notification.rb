class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'Member', foreign_key: :recipient_id, inverse_of: :notifications
end
