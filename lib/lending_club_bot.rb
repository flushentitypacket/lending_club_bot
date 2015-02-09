require 'lending_club'
require 'configuration'

class LendingClubBot

  attr_reader :configuration

  def initialize
    @configuration = Configuration.new
  end

  def configure
    yield configuration
    self
  end

  def run
    require_models
    loans = LendingClub.loans
    loans_to_buy = configuration.strategy.call(loans)
    # purchases = order_loans!(loans_to_buy)
    purchases = loans_to_buy
    configuration.notifier.notify(purchases) if configuration.notifier
    nil
  end

  def self.require_models
    Dir[File.dirname(__FILE__) + '/models/*.rb'].
      each {|file| require file }
    nil
  end

end
