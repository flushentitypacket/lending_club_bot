class Scorer

  # The way this is scored is totally not mathematical. This is purely
  # to start getting some rough scores to see how the bot behaves as
  # a program. Can worry about the math later.
  def self.score(loan)
    amount_factor =
      case loan.loan_amount
      when loan.loan_amount > 20_000
        0
      when loan.loan_amount > 15_000
        10
      when loan.loan_amount > 10_000
        20
      when loan.loan_amount > 5_000
        40
      when loan.loan_amount > 3_000
        70
      when loan.loan_amount > 2_000
        80
      when loan.loan_amount > 1_000
        90
      else
        100
      end

    interest_factor = loan.int_rate * 10

    credit_factor = loan.fico_range_low / 2

    amount_factor + interest_factor + credit_factor
  end

end
