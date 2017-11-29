# frozen_string_literal: true

class Transaction < ApplicationRecord

  ################### RULES OF TRANSACTION ####################
  #                                                           #
  #     The sum of all entries on the asset side must equal   #
  #       the sum of all entries on the liabilities side      #
  #                                                           #
  # For every action, there is an equal and opposite reaction #
  #                                                           #
  #                Source is always a debit                   #
  #             Destination is always a credit                #
  #         Every transaction must always have an equal       #
  #                number of event entries                    #
  #         whereby each corresponds to its opposite          #
  #                                                           #
  #############################################################

  belongs_to :previous_transaction, class_name: self.name, foreign_key: :previous_transaction_id, optional: true

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  belongs_to :source_coin, class_name: "Coin", foreign_key: :source_coin_id
  belongs_to :destination_coin, class_name: "Coin", foreign_key: :destination_coin_id

  belongs_to :initiated_by, class_name: "Member", foreign_key: :initiated_by_id, inverse_of: :initiated_transactions
  belongs_to :authorized_by, class_name: "Member", foreign_key: :authorized_by_id, inverse_of: :authorized_transactions

  has_many :coin_events, foreign_key: :transaction_id, inverse_of: :transact
  has_many :member_coin_events, foreign_key: :transaction_id, inverse_of: :transact

  def readonly?
    (ENV["READONLY_TRANSACTIONS"] == "false") ? false : !new_record?
  end

  TYPES = %w[
    SystemDeposit SystemAllocation SystemWithdrawl
    MemberDeposit MemberAllocation MemberExchange MemberWithdrawl
  ].freeze

  TYPES.each do |type|
    scope type.underscore.to_sym, -> { where type: type }

    define_method "#{type.underscore}?" do
      type == self.type
    end
  end

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_source, ->(source) { where(source: source) }
  scope :for_destination, ->(destination) { where(destination: destination) }

  validates :type, presence: true,
                   inclusion: { in: TYPES }

  validates :initiated_by, presence: true

  validate :correct_previous_transaction

  class << self
    def find_sti_class(type_name)
      type_name = self.name
      super
    end

    def sti_name
      self.name.demodulize
    end
  end

  private

  def correct_previous_transaction
    return true if previous_transaction.blank? || (previous_transaction.id == referring_transaction.id)
    self.errors.add :previous_transaction, "Invalid previous transaction"
  end

  def rates_match
    source_rate_matches = source_rate.to_d == source_coin.btc_rate #.round(Coin::BTC_SUBDIVISION)
    destination_rate_matches = destination_rate.to_d == destination_coin.btc_rate #.round(Coin::BTC_SUBDIVISION)
    return true if source_rate_matches && destination_rate_matches
    self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
  end

  def values_match
    source_value = ((source_quantity * source_rate).round(Coin::BTC_SUBDIVISION) * 10**(Coin::BTC_SUBDIVISION - source_coin.subdivision)).to_i
    destination_value = ((destination_quantity * destination_rate).round(Coin::BTC_SUBDIVISION) * 10**(Coin::BTC_SUBDIVISION - destination_coin.subdivision)).to_i
    return true if (source_value - destination_value).zero?
    self.errors.add :values_match, "Invalid purchase"
  end

  def referring_transaction; end
end