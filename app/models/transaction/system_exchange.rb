# frozen_string_literal: true

module Transaction
  class SystemExchange < Transaction::Base

    validates :source_rate,
              :source_quantity,
              :source_coin,
              :destination_rate,
              :destination_quantity,
              :destination_member,
              :destination_coin,
              presence: true

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_member

    validate :values_match, :rates_match

    before_save :publish_to_source_coin,
                :publish_to_destination_coin,
                :publish_to_member

    private

    def publish_to_source_coin
      # Decrease source coin liability
      # Increase source coin availability
      raise ActiveRecord::Rollback unless source_coin.publish!(
        liability: -source_quantity,
        available: source_quantity,
        transaction_id: self
      )
    end

    def publish_to_destination_coin
      # Increase destination coin liability
      # Decrease destination coin availability
      raise ActiveRecord::Rollback unless destination_coin.publish!(
        liability: destination_quantity,
        available: -destination_quantity,
        transaction_id: self
      )
    end

    def publish_to_member
      # Decrease availability of source coin
      raise ActiveRecord::Rollback unless destination_member.publish!(
        coin: source_coin,
        liability: -source_quantity,
        rate: source_rate,
        transaction_id: self
      )

      # Increase availability of destination coin
      raise ActiveRecord::Rollback unless destination_member.publish!(
        coin: destination_coin,
        liability: destination_quantity,
        rate: destination_rate,
        transaction_id: self
      )
    end

  end
end
