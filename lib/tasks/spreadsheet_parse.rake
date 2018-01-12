
# todo:  some members (highlighted in pink on the original spreadsheet) are 
# having differently formatted transactions (eg: transactions with a rate but 
# no amount) --how to interpret this?

# also we have several entries towards the end of the spreadsheet with duplicate
# name and email, but different transactions. 
# currently this will be handled as multiple transactions for the same member.
# is this correct?

namespace :parse_spreadsheet do
  task :add_data do

    def add_transaction(transaction_params,coin_type,member)
      current_coin = Coin.find_by(code: coin_type)
      # check we have an amount (not all members have a transaction for all types of coin)
      if ! (transaction_params["amount"].nil? || transaction_params["amount"] == 0)
        transaction_params = {
          source: current_coin,
          destination: member,
          source_coin: current_coin,
          destination_coin: current_coin,
          destination_quantity: Utils.to_integer(transaction_params["amount"].to_f,current_coin.subdivision),
          destination_rate: transaction_params["rate"].to_f,
          initiated_by: admin
        }
        transaction = Transactions::MemberDeposit.create!(transaction_params)
      end
    end

    # read in our data  
    data = CSV.read(Rails.root.join("db", "data", "mmt_sample.csv"))

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


    data.each do |row|
      select_params = row[0..11]+row[30..33]
      params = member_columns.zip(select_params).to_h
      
      # check there is a member (some spreadsheet lines at the end have averages etc)
      if ! (params["name"].nil? && params["email"].nil?)
        Member.find_or_initialize_by(email: params["email"]) do |member|
          member.update!(admin: false, password: "password",username: params["name"])
          # can add more member details here
        
          add_transaction(btc_columns.zip(row[btc_range]).to_h, "BTC", member)
          add_transaction(eth_columns.zip(row[eth_range]).to_h, "ETH", member)
          add_transaction(neo_columns.zip(row[neo_range]).to_h, "NEO", member)
  
        end
      end
    end
  end
end





  

