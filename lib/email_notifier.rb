require 'mail'

class EmailNotifier

  attr_reader :from, :to

  def initialize(from, to, options)
    @from = from
    @to = to
    @options = options
  end

  def notify(loans)
    if loans.any?
      email = Mail.new(
        from: @from,
        to: @to,
        subject: subject_with_date,
        body: loans.map { |l| pretty_loan(l) }.join("\n"),
      )
      email.delivery_method(:smtp, @options)
      email.deliver!
    end
  end

  private

  def subject_with_date
    "LendingClubBot results #{Date.today.strftime("%Y/%m/%d")}"
  end

  def pretty_loan(loan)
    link = "https://www.lendingclub.com/browse/loanDetail.action?" \
           "loan_id=#{loan.id}"
    interest_rate = loan.int_rate
    credit_rating = loan.fico_range_low
    dti = loan.dti

    <<-PRETTY_LOAN
      #{link}
      interest rate: #{interest_rate}
      credit rating: #{credit_rating}
      dti: #{dti}
    PRETTY_LOAN
  end
end
