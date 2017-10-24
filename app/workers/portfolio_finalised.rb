module Workers
  class PortfolioFinalised

    def call(event)
      previous_portfolio = find_member(event.data.fetch(:member_id)).live_portfolio
      next_portfolio = find_portfolio(event.data.fetch(:portfolio_id))
      if previous_portfolio
        previous_portfolio.next_portfolio = next_portfolio
      else
        next_portfolio.state = 'finalised'
        next_portfolio.save!
      end
    end

    private

    def find_portfolio(id)
      @portfolio = ::Portfolio.find_by(id: id)
    end

    def find_member(member_id)
      @member = ::Member.find_by(id: member_id)
    end

  end
end
