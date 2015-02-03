require 'lending_club'
require 'configuration'

class LendingClubBot

  attr_reader :configuration

  def initialize
    @configuration = Configuration.new
  end

  def configure
    yield configuration
  end

  def start
    loans = LendingClub.loans
    loans_to_buy = configuration.strategy.call(loans)
    # purchases = order_loans(loans_to_buy)
    # notify(purchases)
  end

end
