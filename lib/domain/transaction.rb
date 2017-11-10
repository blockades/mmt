# frozen_string_literal: true

module Domain
  class Transaction
    include AggregateRoot

    # FUNDAMENTALS

    # Command module acts as the aggregate's data model using ActiveModel::Validations
    # Handler module passes the structured & validated data to the aggregate (Domain::Transaction)
    # Aggregate appends valid events to the relevant stream and triggers dependent events

    # Coin Holdings => Coin currently available
    # Coin Reserve => Overall coin in the system

    attr_reader :source_coin_id,
                :source_rate,
                :source_quantity,
                :destination_coin_id,
                :destination_rate,
                :destination_quantity
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

    # Command::Transaction::Load
    # Handlers::Transaction::Load
    def load!
      apply Events::Transaction::Load.new(data: {
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
        destination_quantity: destination_quantity
        source_coin_id: source_coin_id,
        source_quantity: source_quantity
        source_rate: destination_rate,
        member_id: member_id
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

    # On a load event, we increase both available funds and overall funds
    def apply_load(event)
      coin = ::Coin.find event.data.fetch(:destination_coin_id)
      coin.publish!(Events::Coin::State,
        holdings: coin.holdings += destination_quantity,
        reserves: coin.reserves += destination_quantity,
        rate: destination_rate,
        transaction_id: event.event_id
      )
    end

    def apply_exchange(event)
      source_coin = ::Coin.find event.data.fetch(:source_coin_id)
      destination_coin = ::Coin.find event.data.fetch(:destination_coin_id)
      member = Member.find event.data.fetch(:member_id)

      # Increase the source coin holdings
      # Reserves stay the same
      source_coin.publish!(Events::Coin::State, {
        holdings: source_coin.holdings += source_quantity,
        reserves: source_coin.reserves,
        transaction_id: event.event_id
      })

      # Descrease the destination coin holdings
      # Reserves stay the same
      destination_coin.publish!(Events::Coin::State, {
        holdings: destination_coin.holdings -= destination_quantity,
        reserves: destination_coin.reserves,
        rate: destination_rate,
        transaction_id: event.event_id
      })

      # Increate member holdings of given coin
      member.publish!(Events::Member::Balance, {
        coin_id: destination_coin.id,
        holdings: member.coin_holdings(destination_coin.id) += destination_quantity,
        rate: destination_rate,
        transaction_id: event.event_id
      })
    end

    # On a withdrawl event, we decrease both available funds and overall funds
    def apply_withdraw(event)
      coin = ::Coin.find event.data.fetch(:source_coin_id)
      coin.publish!(Events::Coin::State, {
        holdings: coin.holdings -= source_quantity,
        reserves: coin.reserves -= source_quantity,
        transaction_id: event.event_id
      })
    end
  end
end
