
# should this be moved to gemfile?
require 'csv'


require 'pry'

# probably it is unnessecary to create this class and could just 
# directly add transactions as row data is parsed

class Spreadsheet_transaction
  def initialize(args = {})
    args.each do |k,v|
      instance_variable_set(:"@#{k}", v)
    end
  end

  def add_transaction
    current_coin = Coin.find_by(code: @type)
    transaction_params = {
      source: current_coin,
      destination: member,
      source_coin, current_coin,
      destination_coin: current_coin,
      destination_quantity: @amount,
      destination_rate: @rate,
      initiated_by: admin
    }
    transaction = Transactions::MemberDeposit.create!(transaction_params)
  end

  # can delete this
  def display_transaction
    puts "------------------- #@member_number"
    puts "type: #@type"
    puts "hash: #@hash"
    puts "amount: #@amount"
    puts "rate: #@rate"
    puts "currentvalue: #@current_value"
     puts "difference: #@perc_difference"
  end
end


class Member
  def initialize(args = {})
    args.each do |k,v|
      instance_variable_set(:"@#{k}", v)
    end
  end
  def display_member()
    puts "-----------------------------------------"
    puts "name: #@name"
    puts "email: #@email"
    puts "notes: #@notes"
    puts "ref row: #@ref_row"
    puts "type: #@type"
    puts "date in: #@date_in"
    puts "medium: #@medium"
    puts "high: #@high"
    puts "amount: #@amount"
    puts "usd: #@usd"
    puts "iou: #@iou"
    puts "iouusd: #@iouusd"
    puts "cumold: #@cumold"
    puts "cumcur: #@cumcur"
    puts "percdifference: #@perc_difference"
    puts "diff: #@diff"
  end
end

# read in our data
data = CSV.read('../../data/db/mmt_sample.csv')

# get column names and then remove them
columns = data.first
data = data.drop(1)

# get only column names specific to member (not transaction)
member_columns = columns[0..11]+columns[30..33]

btc_columns = columns[13..17]
eth_columns = columns[19..23]
ans_columns = columns[25..29]

members = []
transactions = []
member_count = 0


data.each do |row|
  select_params = row[0..11]+row[30..33]
  params = member_columns.zip(select_params).to_h
  members.push(Member.new(params))
  
  member_count+=1
  #binding.pry
  btcparams = btc_columns.zip(row[13..17]).to_h
  btcparams[:member_number] = member_count 
  btcparams[:type] = "BTC"
  transactions.push(Spreadsheet_transaction.new(btcparams))
  
  # repeat for eth and neo

  ethparams = btc_columns.zip(row[19..23]).to_h
  ethparams[:member_number] = member_count 
  ethparams[:type] = "ETH"
  transactions.push(Spreadsheet_transaction.new(ethparams))

  neoparams = btc_columns.zip(row[25..29]).to_h
  neoparams[:member_number] = member_count 
  neoparams[:type] = "NEO"
  transactions.push(Spreadsheet_transaction.new(ethparams))
end

#members[0].display_member()
#transactions[0].display_transaction()

#name,email,notes,ref_row,type,date_in,medium,high,amount,usd,iou,iouusd,crypto1,btchash,btcamount,btcrate,btccurrent_value,btc_perc_difference,crypto2,ethhash,ethamount,ethrate,eth_current_value,eth_perc_difference,crypto 3,neohash,neo_amount,neo_rate,neo_current_value,neo_perc_difference,CUMOLD,CUMCUR,perc_difference,diff

