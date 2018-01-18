# frozen_string_literal: true

namespace :db do
  namespace :seed do
    task :spreadsheet do
      MemberCoinEvent.delete_all
      CoinEvent.delete_all
      SystemTransaction.delete_all

      ActiveRecord::Base.transaction do
        # Initialize an admin
        admin = Member.find_or_initialize_by(email: "develop@blockades.dev").tap do |admin|
          admin.update!(username: "develop", password: "password", admin: true)
        end

        # Load CSV
        data = CSV.table(Rails.root.join("db", "data", "mmt_sample.csv"))

        # Layout transaction types based on type column accessor
        transaction_types = {
         B: { klass: Transactions::MemberDeposit, member: :destination, coin: :source },
         S: { klass: Transactions::MemberWithdrawl, member: :source, coin: :destination }
        }

        # Find relevant coins
        btc = Coin.find_by(code: "BTC")
        neo = Coin.find_by(code: "NEO")
        eth = Coin.find_by(code: "ETH")
        raise ActiveRecord::RecordNotFound unless btc && neo && eth

        data.each_with_index do |row, i|
          # Skip if no entry for a member
          next if row[:email].nil?
          # Find or create new member based on email
          member = Member.find_or_initialize_by(email: row[:email].strip).tap do |member|
            member.update!(password: "password", username: row[:name]) unless member.persisted?
          end
          # Date to set transaction created_at
          date = Date.parse(row[:date_in])
          # For each coin
          [btc, neo, eth].each do |coin|
            # Grab relevant columns (hash is coin quantity) to slice from row
            args = ["hash", "rate"].map do |field|
              "#{coin.code.downcase}_#{field}".to_sym
            end
            # Slice from row and remove coin code prefix
            data = row.to_h.slice(*args).transform_keys {|key| key.to_s.sub(/^\w+\_/, "").to_sym }
            # Skip to next coin if no quantity
            next if data[:hash].nil? || data[:hash].zero?
            # Find relevant transaction based on type column, buy (B) or sell (S)
            transaction_info = transaction_types[row[:type].to_sym]
            # Calculate btc_rate to relevant coin if bitcoin has an entry
            btc_rate = data[:rate] / (row[:btc_rate]) unless row[:btc_rate].nil? || row[:btc_rate].zero?
            # Find relevant transaction class and polymorphic type (:source or :destination)
            transaction_klass = transaction_info[:klass]
            transaction_member = transaction_info[:member]
            transaction_coin = transaction_info[:coin]
            # Layout transaction parameters
            params = {
              "#{transaction_member}" => member,
              "#{transaction_coin}" => coin,
              "source_coin" => coin,
              "destination_coin" => coin,
              # Ensure data is a positive input and is stored as an integer
              "#{transaction_member}_quantity" => Utils.to_integer(data[:hash].abs, coin.subdivision),
              "#{transaction_member}_rate" => btc_rate || nil,
              "initiated_by" => admin
            }
            # Create the relevant transaction
            transaction = transaction_klass.new(params).tap do |transaction|
              transaction.created_at = date
              transaction.save!
            end
            puts <<-STR
#{transaction.class} no. #{i} =>  {
  coin: #{transaction.send(transaction_coin).code},
  member: #{transaction.send(transaction_member).email},
  quantity: #{transaction.send("#{transaction_member}_quantity")},
  rate: #{transaction.send("#{transaction_member}_rate")},
  date: #{transaction.created_at}
}
            STR
          end
        end
      end
    end
  end
end

task "db:seed:spreadsheet" => "setup"
