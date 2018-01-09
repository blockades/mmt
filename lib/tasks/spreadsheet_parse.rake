
# keiran:  for sure this wont run, but it should give a gist of how i thought to do it
# comments very welcome!

# should this be moved to gemfile?
require 'csv'


#require 'pry'


# how are members uniquely referred to in transactions?  username?
def add_transaction(transaction_params,coin_type,username)
  current_coin = Coin.find_by(code: coin_type)
  transaction_params = {
    source: current_coin,
    destination: member,
    source_coin, current_coin,
    destination_coin: current_coin,
    destination_quantity: transaction_params["amount"],
    destination_rate: transaction_params["rate"],
    initiated_by: admin
  }
  transaction = Transactions::MemberDeposit.create!(transaction_params)
end

# read in our data
data = CSV.read('../../data/db/mmt_sample.csv')


# get column names and then remove them
columns = data.first
data = data.drop(1)

# get only column names specific to member (not transaction)
member_columns = columns[0..11]+columns[30..33]

btc_range = 13..17
eth_range = 19..23
neo_range = 25..29

btc_columns = columns[btc_range]
eth_columns = columns[eth_range]
neo_columns = columns[neo_range]


# should the namespace be something else?
namespace :setup do
  task members: :environment do


    data.each do |row|
      select_params = row[0..11]+row[30..33]
      params = member_columns.zip(select_params).to_h
    
      Member.find_or_initialize_by(email: params["email"]) do |member|
        member.update!(admin: false, password: "password", username: params["name"])
        # can add more member details here
        
        add_transaction(btc_columns.zip(row[btc_range]).to_h, "BTC", params["name"])
        add_transaction(eth_columns.zip(row[eth_range]).to_h, "ETH", params["name"])
        add_transaction(neo_columns.zip(row[neo_range]).to_h, "NEO", params["name"])
  
      end
    end
  end


  task all: [:members]
end

task setup: "setup:all"




  

