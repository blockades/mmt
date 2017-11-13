# frozen_string_literal: true

module Domain
  class Transaction
    include AggregateRoot

    ValidationError = Class.new(StandardError)

    # FUNDAMENTALS

    # Coin Holdings => Coin currently available
    # Coin Reserve => Overall coin in the system

    attr_reader :source_coin_id,
                :source_rate,
                :source_quantity,
                :destination_coin_id,
                :destination_rate,
                :destination_quantity,
                :member_id,
                :admin_id

    def initialize(source_coin_id: nil,
                   source_quantity: nil,
                   source_rate: nil,
                   destination_coin_id: nil,
                   destination_quantity: nil,
                   destination_rate: nil,
                   member_id: nil,
                   admin_id: nil)

      @source_coin_id = source_coin_id
      @source_rate = source_rate
      @source_quantity = source_quantity
      @destination_coin_id = destination_coin_id
      @destination_rate = destination_rate
      @destination_quantity = destination_quantity
      @member_id = member_id
      @admin_id = admin_id
    end

    # Perform relevant action based on information which has been passed
    def append_to_stream!
      if system_deposit_event?
        self.system_deposit!
      elsif exchange_event?
        self.exchange!
      elsif allocate_event?
        self.allocate!
      elsif withdraw_event?
        self.withdraw!
      else
        raise ArgumentError, "Arguments supplied do not fit any event trigger"
      end
    end

    # ====> Admin 'loads' funds into the system
    def system_deposit!
      raise ValidationError unless destination_coin
      raise ValidationError unless numerical(destination_rate) && destination_quantity.kind_of?(Integer)
      raise ValidationError unless positive(destination_rate) && positive(destination_quantity)

      self.load(stream)
      apply Events::Transaction::SystemDeposit.new(data: {
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_quantity,
        admin_id: admin_id
      })
      self.store
    end

    # ===> Member moves funds from Coin A to Coin B
    def exchange!
      raise ValidationError unless destination_coin && source_coin
      raise ValidationError unless numerical(destination_rate) && destination_quantity.kind_of?(Integer) &&
                                   numerical(source_rate) && source_quantity.kind_of?(Integer)
      raise ValidationError unless positive(destination_rate) && positive(destination_quantity) &&
                                   positive(source_rate) && positive(source_quantity)
      raise ValidationError unless current_source_coin_balance &&
                                   ensure_less_than_central_reserve &&
                                   values_square && rates_match
      self.load(stream)
      apply Events::Transaction::Exchange.new(data: {
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_quantity,
        source_coin_id: source_coin_id,
        source_quantity: source_quantity,
        source_rate: destination_rate,
        member_id: member_id
      })
      self.store
    end

    # ===> Assign value to member
    def allocate!
      raise ValidationError unless destination_coin
      raise ValidationError unless numerical(destination_rate) && destination_quantity.kind_of?(Integer) &&
                                   positive(destination_rate) && positive(destination_quantity)
      raise ValidationError unless ensure_less_than_central_reserve

      self.load(stream)
      apply Events::Transaction::Allocate.new(data: {
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_quantity,
        member_id: member_id,
        admin_id: admin_id
      })
      self.store
    end

    # ===> Member withdraws funds
    def withdraw!
      raise ValidationError unless source_coin && source_quantity.kind_of?(Integer) && positive(source_quantity)

      self.load(stream)
      apply Events::Transaction::Withdraw.new(data: {
        source_coin_id: source_coin_id,
        source_quantity: source_quantity,
        member_id: member_id
      })
      self.store
    end

    private

    # ===> Event Stream

    def stream
      "Domain::Transaction"
    end

    # ===> Aggregate methods to do something before event commited...

    def apply_system_deposit(event)
    end

    def apply_allocate(event)
    end

    def apply_exchange(event)
    end

    def apply_withdraw(event)
    end

    # ===> Event trigger logic

    def system_deposit_event?
      destination_coin_id.present? && destination_rate.present? &&
        destination_quantity.present? && source_coin_id.blank? &&
        source_rate.blank? && source_quantity.blank? &&
        member_id.blank? && admin_id.present?
    end

    def exchange_event?
      destination_coin_id.present? && destination_rate.present? &&
        destination_quantity.present? && source_coin_id.present? &&
        source_rate.present? && source_quantity.present? &&
        member_id.present? && admin_id.blank?
    end

    def allocate_event?
      destination_coin_id.present? && destination_rate.present? &&
        destination_quantity.present? && source_coin_id.blank? &&
        source_rate.blank? && source_quantity.blank? &&
        member_id.present? && admin_id.present?
    end

    def withdraw_event?
      destination_coin_id.blank? && destination_rate.blank? &&
        destination_quantity.blank? && source_coin_id.present? &&
        source_quantity.present? && source_rate.blank? &&
        member_id.present? && admin_id.blank?
    end

    # ===> Helpers

    def destination_coin
      @destination_coin ||= ::Coin.find(destination_coin_id)
    end

    def source_coin
      @source_coin ||= ::Coin.find(source_coin_id)
    end

    # ===> Validation Methods

    def current_source_coin_balance
      source_coin_balance = member.holdings(source_coin_id)
      source_quantity < source_coin_balance
    end

    def rates_match
      source_rate_matches = BigDecimal.new(source_rate) == source_coin.btc_rate
      destination_rate_matches = BigDecimal.new(destination_rate) == destination_coin.btc_rate
      source_rate_matches && destination_rate_matches
    end

    def values_square
      # This fails when coin subdivisions do not match
      # e.g. when buying Sterling with Bitcoin
      # Need to multiply both by the HIGHEST subdivision to standardise value comparison
      source_value = (source_quantity * source_rate.to_d).round(0).to_i
      destination_value = (destination_quantity * destination_rate.to_d).round(0).to_i
      (source_value - destination_value).zero?
    end

    def ensure_less_than_central_reserve
      destination_coin && destination_quantity < destination_coin.reload.holdings
    end

    def ensure_less_than_balance
      member = ::Member.find member_id
      member && source_quantity < member.holdings(source_coin_id)
    end

    def numerical(value)
      # This fails when a number is a whole integer
      (value.to_d.to_s == value)
    end

    def positive(value)
      value.to_d > 0
    end
  end
end
