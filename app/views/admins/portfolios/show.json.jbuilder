json.call(@portfolio, :id, :initial_btc_value, :btc_value)
json.assets @portfolio.assets, :coin_id, :initial_btc_rate, :quantity
