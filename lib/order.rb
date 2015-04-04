require 'api'
require 'models'

class Order

  include Models

  attr_reader :loans

  def initialize(loans, options = {})
    @loans = loans
    @client = options[:client] || Api.new(dry_run: options[:dry_run])
  end

  # TODO(flush): This has somewhat restricted functionality since it only
  # buys a single share of the loan with no option to change.
  # Should make that configurable.
  def execute!
    orders = loans.map do |loan|
      single_share_amount = BigDecimal.new(25)
      order = @client.build_order(loan.id, single_share_amount)

      order
    end

    @client.execute_orders!(orders)
    successful_loan_ids = orders.reject { |order| order.success? }.map(&:loan_id)

    successful_purchases = loans.select do |loan|
      successful_loan_ids.include?(loan.id)
    end

    successful_purchases.each { |purchase| record_purchase(purchase) }

    successful_purchases
  end

  def dry_run?
    return true if @dry_run.nil?
    !!@dry_run
  end

  private

  def record_purchase(loan)
    if Loan.where(id: loan.id).empty?
      Loan.new.tap do |_loan_model|
        _loan_model.id = loan.id
        _loan_model.json = loan.to_h
      end.save
    end

    PurchasedNote.new.tap do |note_model|
      note_model.loan_id = loan.id
      note_model.purchased_at = Time.now
    end.save

    return nil
  end

end
