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
    "LendingClubBot results #{Date.today.strftime("%B %d %Y")}"
  end

  def pretty_loan(loan)
    link = "https://www.lendingclub.com/browse/loanDetail.action?" \
           "loan_id=#{loan.id}"
    # TODO Pretty loan summary
    link
  end
end
