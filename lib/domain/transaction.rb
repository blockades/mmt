# frozen_string_literal: true

module Domain
  class Transaction
    include AggregateRoot

    # FUNDAMENTALS

    # Command classes act as the aggregate's data model using ActiveModel::Validations
    # Handler module passes the structured & validated data to the aggregate (Domain::Transaction)
    # Aggregate appends valid events to the relevant stream and triggers subscribers

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

    # Command::Transaction::SystemDeposit
    # Handlers::Transaction::SystemDeposit
    def system_deposit!
      apply Events::Transaction::SystemDeposit.new(data: {
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_quantity,
        admin_id: admin_id
      })
    end

    # Command::Transaction::Exchange
    # Handlers::Transaction::Exchange
    def exchange!
      apply Events::Transaction::Exchange.new(data: {
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_quantity,
        source_coin_id: source_coin_id,
        source_quantity: source_quantity,
        source_rate: destination_rate,
        member_id: member_id
      })
    end

    # Command::Transaction::Allocate
    # Handlers::Transaction::Allocate
    def allocate!
      apply Events::Transaction::Allocate.new(data: {
        destination_coin_id: destination_coin_id,
        destination_rate: destination_rate,
        destination_quantity: destination_quantity,
        member_id: member_id,
        admin_id: admin_id
      })
    end

    # Command::Transaction::Withdraw
    # Handlers::Transaction::Withdraw
    def withdraw!
      apply Events::Transaction::Withdraw.new(data: {
        source_coin_id: source_coin_id,
        source_quantity: source_quantity,
        member_id: member_id
      })
    end

    private

    # This prevents the apply_... method callback
    def apply_strategy
      DefaultApplyStrategy.new(strict: false)
    end
  end
end
