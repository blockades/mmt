json.call(@portfolio, :id, :initial_btc_value, :btc_value)
json.holdings @portfolio.holdings, :coin_id, :initial_btc_rate, :quantity
