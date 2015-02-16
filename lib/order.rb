require 'lending_club'
require 'models'

class Order

  include Models

  attr_reader :loans

  def initialize(loans, options = {})
    require_models
    @loans = loans
    @dry_run = options[:dry_run]
  end

  # TODO(flush): This has somewhat restricted functionality since it only
  # buys a single share of the loan with no option to change.
  # Should make that configurable.
  def execute!
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

    LendingClub.order(orders) unless dry_run?

    loans
  end

  def dry_run?
    !!@dry_run
  end

end
