require 'lending_club'
require 'configuration'
require 'connection'
require 'models'

class LendingClubBot
  include Connection
  include Models
  attr_reader :configuration

  def initialize
    @configuration = Configuration.new
  end

  def configure
    yield configuration
    self
  end

  def run
    connect
    require_models
    loans = LendingClub.loans
    loans_to_buy = configuration.strategy.call(loans)
    purchases = order_loans!(loans_to_buy, dry_run: true)
    purchases = loans_to_buy
    configuration.notifier.notify(purchases) if configuration.notifier
    nil
  end

  private

  # TODO(flush): This has somewhat restricted functionality since it only
  # buys a single share of the loan with no option to change.
  # Should make that configurable.
  # TODO(flush): This ordering functionality should be moved to another
  # class, since it's sensitive enough to be tested directly.
  def order_loans!(loans, options = {})
    orders = loans.map do |loan|
      single_share_amount = BigDecimal.new(25)
      LendingClub::Order.new(loan.id, single_share_amount)

      PurchasedNote.new.tap do |note_model|
        # TODO(flush): There must be a cleaner way to do this, but being
        # a Sequel noob has its disadvantages.
        loan_model = Loan.where(id: loan.id).first
        unless loan_model
          loan_model = Loan.new
          loan_model.id = loan.id
          loan_model.json = loan.to_h
          loan_model.save
        end
        note_model.loan = loan_model
        note_model.purchased_at = Time.now
      end.save

    end

    LendingClub.order(orders) unless options[:dry_run]
    loans
  end

end
