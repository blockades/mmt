# frozen_string_literal: true

# Transaction events
Events::Transaction::Load = Class.new(RailsEventStore::Event)
Events::Transaction::Exchange = Class.new(RailsEventStore::Event)
Events::Transaction::Withdraw = Class.new(RailsEventStore::Event)

# Change state of coin
Events::Coin::State = Class.new(RailsEventStore::Event)

# Change member balance
Events::Member::Balance = Class.new(RailsEventStore::Event)
