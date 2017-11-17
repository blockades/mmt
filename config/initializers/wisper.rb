# frozen_string_literal: true

Wisper.subscribe(Subscribers::Transaction::SystemAllocation.new, scope: ::Transaction::SystemAllocation)
Wisper.subscribe(Subscribers::Transaction::SystemWithdrawl.new, scope: ::Transaction::SystemWithdrawl)
Wisper.subscribe(Subscribers::Transaction::SystemDeposit.new, scope: ::Transaction::SystemDeposit)
Wisper.subscribe(Subscribers::Transaction::SystemExchange.new, scope: ::Transaction::SystemExchange)

Wisper.subscribe(Subscribers::Transaction::MemberAllocation.new, scope: ::Transaction::MemberAllocation)
Wisper.subscribe(Subscribers::Transaction::MemberWithdrawl.new, scope: ::Transaction::MemberWithdrawl)
Wisper.subscribe(Subscribers::Transaction::MemberDeposit.new, scope: ::Transaction::MemberDeposit)
Wisper.subscribe(Subscribers::Transaction::MemberExchange.new, scope: ::Transaction::MemberExchange)
