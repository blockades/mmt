

namespace :parse_spreadsheet do
  task add_data: do

    def add_transaction(transaction_params,coin_type,member)
      current_coin = Coin.find_by(code: coin_type)
      transaction_params = {
        source: current_coin,
        destination: member,
        source_coin, current_coin,
        destination_coin: current_coin,
        destination_quantity: Utils.to_integer(transaction_params["amount"].to_f,current_coin.subdivision),
        destination_rate: transaction_params["rate"].to_f,
        initiated_by: admin
      }
      transaction = Transactions::MemberDeposit.create!(transaction_params)
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
    
      Member.find_or_initialize_by(email: params["email"]) do |member|
        member.update!(admin: false, password: "password", member)
        # can add more member details here
        
        add_transaction(btc_columns.zip(row[btc_range]).to_h, "BTC", params["name"])
        add_transaction(eth_columns.zip(row[eth_range]).to_h, "ETH", params["name"])
        add_transaction(neo_columns.zip(row[neo_range]).to_h, "NEO", params["name"])
  
      end
    end
  end
end





  

