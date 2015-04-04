require 'lending_club'

class Api
  attr_reader :client

  def initialize(options = {})
    @dry_run = !!options.fetch(:dry_run, true)
    @client = options.fetch(:client, LendingClub)
    @credentials = options[:credentials]
    set_credentials
  end

  # @return [Array<LendingClub::Loan>]
  def loans
    LendingClub.loans
  end

  # @param [Array<Order>] WARNING mutates!
  # @return [Array<Order>]
  def execute_orders!(orders)
    return orders if dry_run?

    unless orders.map(&:loan_id).uniq.length == orders.length
      raise ArgumentError, 'orders must have unique loan_id'
    end

    lc_orders = orders.map do |order|
      @client.build_order(order.loan_id, order.amount)
    end

    sent_lc_orders = @client.order(lc_orders)
    sent_lc_orders_by_loan_id = sent_lc_orders.index_by(&:loan_id)
    sent_lc_orders_by_loan_id.each do |loan_id, sent_lc_order|
      if sent_lc_order.fulfilled?
        order.status = :success
      else
        order.status = :failure
      end
    end
    orders
  end

  def build_order(loan_id, amount)
    Order.new(loan_id, amount)
  end

  def dry_run?
    @dry_run
  end

  # @private
  class Order
    SINGLE_SHARE_AMOUNT = 25
    attr_reader :loan_id, :amount

    def initialize(loan_id, amount = SINGLE_SHARE_AMOUNT)
      @loan_id = loan_id
      @amount = amount
    end

    def success?
      @status == :success
    end
  end

  private

  def set_credentials
    if @credentials
      client.access_token = @credentials['access_token']
      client.investor_id = @credentials['investor_id']
    end
    nil
  end

end
