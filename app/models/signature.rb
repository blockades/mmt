class Signature < ApplicationRecord
  belongs_to :system_transaction, class_name: "Transactions::Base",
                                  foreign_key: :system_transaction_id,
                                  inverse_of: :signatures

  belongs_to :signee, class_name: "Member",
                      foreign_key: :member_id,
                      inverse_of: :signatures

  validates :member_id, uniqueness: { scope: :system_transaction_id }
end
