# frozen_string_literal: true

class ExchangeCoins
  include Interactor
  include Command::Execute

  def call
    context.fail!(message: "Missing fields") unless (required_params - permitted_params.keys).empty?
    command = Command::Transaction::Exchange.new(exchange_params)
    execute command
    context.message = "Success"
  rescue Command::ValidationError => error
    context.fail!(message: "Fail: #{error.inspect}")
  end

  protected

  def required_params
    [:destination_coin_id, :destination_rate, :destination_quantity, :source_coin_id, :source_rate, :source_quantity]
  end

  def exchange_params
    permitted_params.merge(
      destination_coin_id: destination_coin.id,
      destination_quantity_for_comparison: quantity_as_integer(:destination_quantity, higher_subdivision),
      destination_quantity: quantity_as_integer(:destination_quantity, destination_coin.subdivision),
      source_quantity_for_comparison: quantity_as_integer(:source_quantity, higher_subdivision),
      source_quantity: quantity_as_integer(:source_quantity, source_coin.subdivision),
    ).to_h.symbolize_keys
  end

  private

  def permitted_params
    context.permitted_params.to_h.symbolize_keys
  end

  def source_coin
    @source_coin ||= ::Coin.friendly.find permitted_params.fetch(:source_coin_id)
  end

  def destination_coin
    @destination_coin ||= ::Coin.friendly.find permitted_params.fetch(:destination_coin_id)
  end

  def higher_subdivision
    [source_coin, destination_coin].max do |coin_a, coin_b|
      coin_a.subdivision <=> coin_b.subdivision
    end.subdivision
  end

  def quantity_as_integer(param, subdivision)
    (permitted_params.fetch(param).to_d * 10**subdivision).to_i
  end
end
