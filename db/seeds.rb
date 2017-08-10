# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create email: 'admin@mmt.blockades.org', password: 'admin123', admin: true

User.create email: 'bob.j.bobess@farcical.net', password: '123456'
User.create email: 'j.a.funky@hotmail.net', password: '123456'
User.create email: 'danny@jman.net', password: '123456'

btc = Coin.create name: 'Bitcoin', code: 'BTC'
eth = Coin.create name: 'Ethereum', code: 'ETH'
ans = Coin.create name: 'Antshares', code: 'ANS'

high = Plan.create name: 'High'
medium = Plan.create name: 'Medium'
low = Plan.create name: 'Low'

# btc_values = HTTParty.get('https://api.coinbase.com/v2/exchange-rates?currency=BTC').parsed_response['data']['rates']
# usd_to_btc = BigDecimal.new btc_values['USD']

# eth_values = HTTParty.get('https://api.coinbase.com/v2/exchange-rates?currency=ETH').parsed_response['data']['rates']
# usd_to_eth = BigDecimal.new eth_values['USD']

# ans_vs_btc = HTTParty.get('https://bittrex.com/api/v1.1/public/getticker?market=BTC-ANS').parsed_response['result']['Last']
# ans_vs_btc = BigDecimal.new ans_vs_btc.to_s
# usd_to_ans = usd_to_btc * ans_vs_btc

# btc_now = CoinTimestamp.create amount: usd_to_btc, coin_id: btc.id
# eth_now = CoinTimestamp.create amount: usd_to_eth, coin_id: eth.id
# ans_now = CoinTimestamp.create amount: usd_to_ans, coin_id: ans.id


