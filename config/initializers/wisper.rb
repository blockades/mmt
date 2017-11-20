# frozen_string_literal: true

Wisper.subscribe(Subscribers::Transactions::SystemAllocation.new, scope: ::Transaction::SystemAllocation)
Wisper.subscribe(Subscribers::Transactions::SystemWithdrawl.new, scope: ::Transaction::SystemWithdrawl)
Wisper.subscribe(Subscribers::Transactions::SystemDeposit.new, scope: ::Transaction::SystemDeposit)
Wisper.subscribe(Subscribers::Transactions::SystemExchange.new, scope: ::Transaction::SystemExchange)

Wisper.subscribe(Subscribers::Transactions::MemberAllocation.new, scope: ::Transaction::MemberAllocation)
Wisper.subscribe(Subscribers::Transactions::MemberWithdrawl.new, scope: ::Transaction::MemberWithdrawl)
Wisper.subscribe(Subscribers::Transactions::MemberDeposit.new, scope: ::Transaction::MemberDeposit)
Wisper.subscribe(Subscribers::Transactions::MemberExchange.new, scope: ::Transaction::MemberExchange)
